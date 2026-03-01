#!/usr/bin/env python3
"""
Batch palette swap driver for the comprehensive sprite reassignment.

Defines all palette swaps, generates batch JSON configs, and runs them.
Uses palette_swap.py's recolor_image function directly for efficiency.

Usage:
    python tools/batch_palette_swaps.py [--tree TREE] [--dry-run]
"""

import argparse
import shutil
import sys
from pathlib import Path

from PIL import Image

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
PROCESSED_DIR = PROJECT_DIR / "assets" / "art" / "sprites" / "processed"

# Import recolor function from palette_swap
sys.path.insert(0, str(SCRIPT_DIR))
from palette_swap import recolor_image, analyze_hues

ANIMS = ["idle", "walk", "attack", "hurt", "death"]

# ---------------------------------------------------------------------------
# Swap definitions: (source_id, output_id, from_hue, to_hue, kwargs)
# kwargs can include: hue_tolerance, lightness_shift, saturation_shift
# ---------------------------------------------------------------------------

# Elemental hue targets
ICE_BLUE = 200
WATER_BLUE = 240
FIRE_RED = 5
EARTH_BROWN = 35
LIGHTNING_YELLOW = 55
WIND_GREEN = 130
ROYAL_GOLD = 45
HOLY_WHITE_LIGHTNESS = 0.15  # used with desaturation

SQUIRE_SWAPS = [
    # Duelist F: medieval_warrior_girl → match samurai_3 (10° → 20°)
    ("chibi_medieval_warrior_girl", "chibi_medieval_warrior_girl_duelist", 10, 20, {}),
    # Cavalry F: amazon_warrior_2 → match medieval_commander (10° → 30°)
    ("chibi_amazon_warrior_2", "chibi_amazon_warrior_2_cavalry", 10, 30, {}),
    # Dragoon F: spartan → blonde hair/darker helmet (30° → 50°, slight darken)
    ("chibi_spartan_knight_warrior_spartan_knight_with_spear",
     "chibi_spartan_knight_warrior_spartan_knight_with_spear_f",
     30, 50, {"lightness_shift": -0.03}),
    # Ranger F: elf_archer_2 → match archer_1 colors (20° → 20°, just copy essentially)
    ("chibi_elf_archer_archer_2", "chibi_elf_archer_archer_2_ranger", 20, 25, {}),
    # Mercenary F: hue diff (10° → 340°, slightly pink/lighter)
    ("chibi_mercenaries_1", "chibi_mercenaries_1_f", 10, 340, {"lightness_shift": 0.05}),
    # Hunter F: forest_ranger_1 → match elf_archer_2 colors (70° → 20°)
    ("chibi_forest_ranger_1", "chibi_forest_ranger_1_hunter", 70, 20, {}),
    # Warden F: hue diff (30° → 0°, lighter)
    ("chibi_armored_knight_templar_knight", "chibi_armored_knight_templar_knight_f",
     30, 0, {"lightness_shift": 0.05}),
    # Bastion F: hue diff (30° → 350°, lighter)
    ("chibi_king_defender_sergeant_very_heavy_armored_frontier_defender",
     "chibi_king_defender_sergeant_very_heavy_armored_frontier_defender_f",
     30, 350, {"lightness_shift": 0.05}),
    # Martial Artist F: priest_1 → match monk colors (20° → 30°)
    ("chibi_priest_1", "chibi_priest_1_martial_artist", 20, 30, {}),
    # Monk F: hue diff (20° → 350°, lighter)
    ("chibi_spiritual_monk_1", "chibi_spiritual_monk_1_f",
     20, 350, {"lightness_shift": 0.05}),
]

ROYAL_SWAPS = [
    # Prince M: medieval_knight → royal gold/blue (20° → 45°)
    ("chibi_armored_knight_medieval_knight", "chibi_armored_knight_medieval_knight_royal",
     20, ROYAL_GOLD, {"saturation_shift": 0.1}),
    # Princess/Prince F: amazon_warrior_1 → royal (40° → 45°, more saturated)
    ("chibi_amazon_warrior_1", "chibi_amazon_warrior_1_royal",
     40, ROYAL_GOLD, {"saturation_shift": 0.1}),
]

MAGE_SWAPS = [
    # Mage M: blonde hair variant (190° → 50°, shift blue → yellow for hair)
    ("chibi_magician_1", "chibi_magician_1_blonde", 190, 50, {"hue_tolerance": 40}),
    # Mage F: white clothes (190° → 190°, desaturate + lighten)
    ("chibi_magician_1", "chibi_magician_1_white", 190, 200,
     {"saturation_shift": -0.3, "lightness_shift": 0.1}),

    # T1 males: dark_oracle_1 (180° cyan) → elemental recolors
    # Mistweaver: already 180° (cyan-ish/blue-ish) - shift slightly more blue
    ("chibi_dark_oracle_1", "chibi_dark_oracle_1_mistweaver", 180, 220, {}),
    ("chibi_dark_oracle_1", "chibi_dark_oracle_1_firebrand", 180, FIRE_RED, {}),
    ("chibi_dark_oracle_1", "chibi_dark_oracle_1_stormcaller", 180, LIGHTNING_YELLOW, {}),

    # T1 females: pyromancer_2 (20° warm) → elemental recolors
    ("chibi_pyromancer_2", "chibi_pyromancer_2_mistweaver", 20, WATER_BLUE, {}),
    ("chibi_pyromancer_2", "chibi_pyromancer_2_firebrand", 20, FIRE_RED, {}),
    ("chibi_pyromancer_2", "chibi_pyromancer_2_stormcaller", 20, LIGHTNING_YELLOW, {}),

    # T2 Mistweaver branch M: shaman_of_thunder_2 (10°) → ice/water
    ("chibi_shaman_of_thunder_2", "chibi_shaman_of_thunder_2_cryomancer", 10, ICE_BLUE, {}),
    ("chibi_shaman_of_thunder_2", "chibi_shaman_of_thunder_2_hydromancer", 10, WATER_BLUE, {}),
    # T2 Mistweaver branch F: winter_witch_1 (220°) → ice/water
    ("chibi_winter_witch_1", "chibi_winter_witch_1_cryomancer", 220, ICE_BLUE, {}),
    ("chibi_winter_witch_1", "chibi_winter_witch_1_hydromancer", 220, WATER_BLUE, {}),

    # T2 Firebrand branch M: magician_3 (190°) → fire/earth
    ("chibi_magician_3", "chibi_magician_3_pyromancer", 190, FIRE_RED, {}),
    ("chibi_magician_3", "chibi_magician_3_geomancer", 190, EARTH_BROWN, {}),
    # T2 Firebrand branch F: medieval_hooded_girl (0° red) → fire/earth
    ("chibi_fantasy_warrior_medieval_hooded_girl",
     "chibi_fantasy_warrior_medieval_hooded_girl_pyromancer", 0, FIRE_RED, {}),
    ("chibi_fantasy_warrior_medieval_hooded_girl",
     "chibi_fantasy_warrior_medieval_hooded_girl_geomancer", 0, EARTH_BROWN, {}),

    # T2 Stormcaller branch M: magician_undead_magician_3 (190°) → lightning/wind
    ("chibi_magician_undead_magician_3",
     "chibi_magician_undead_magician_3_electromancer", 190, LIGHTNING_YELLOW, {}),
    ("chibi_magician_undead_magician_3",
     "chibi_magician_undead_magician_3_tempest", 190, WIND_GREEN, {}),
    # T2 Stormcaller branch F: witch_3 (160°) → lightning/wind
    ("chibi_witch_3", "chibi_witch_3_electromancer", 160, LIGHTNING_YELLOW, {}),
    ("chibi_witch_3", "chibi_witch_3_tempest", 160, WIND_GREEN, {}),

    # Acolyte F: ghost_knight_3 → white/holy (40° → 40°, desaturate + lighten)
    ("chibi_ghost_knight_3", "chibi_ghost_knight_3_acolyte", 40, 40,
     {"saturation_shift": -0.4, "lightness_shift": HOLY_WHITE_LIGHTNESS}),
    # Priest F: hue diff
    ("chibi_priest_3", "chibi_priest_3_f", 20, 350, {"lightness_shift": 0.05}),
    # Paladin F: valkyrie_3 → match paladin_1 (30° → 40°)
    ("chibi_valkyrie_3", "chibi_valkyrie_3_paladin", 30, 40, {}),
]

ENTERTAINER_SWAPS = [
    # Bard F: women_citizen_women_3 → match old_hero_1 (90° → 20°)
    ("chibi_women_citizen_women_3", "chibi_women_citizen_women_3_bard", 90, 20, {}),
    # Warcrier F: valkyrie_3 → match viking_1 (30° → 20°)
    ("chibi_valkyrie_3", "chibi_valkyrie_3_warcrier", 30, 20, {}),
    # Minstrel M: vampire_hunter_1 → positive/warmer (30° → 40°, lighter)
    ("chibi_vampire_hunter_1", "chibi_vampire_hunter_1_minstrel",
     30, 40, {"lightness_shift": 0.05, "saturation_shift": -0.05}),
    # Minstrel F: witch_1 → positive, match minstrel M (260° → 40°)
    ("chibi_witch_1", "chibi_witch_1_minstrel", 260, 40,
     {"lightness_shift": 0.05, "saturation_shift": -0.05}),
    # Dervish F: amazon_warrior_3 → match persian (40° → 10°)
    ("chibi_amazon_warrior_3", "chibi_amazon_warrior_3_dervish", 40, 10, {}),
    # Illusionist F: dark_oracle_2 lighter hue
    ("chibi_dark_oracle_2", "chibi_dark_oracle_2_f",
     260, 280, {"lightness_shift": 0.08}),
    # Mime M/F: mimic_2 → human skin tones (20° → 25°, desaturate green, warm up)
    ("chibi_mimic_2", "chibi_mimic_2_human",
     20, 25, {"saturation_shift": -0.1, "lightness_shift": 0.05}),
    # Orator F: women_citizen_women_1 → match citizen_1 (already similar ~20°, minor)
    ("chibi_women_citizen_women_1", "chibi_women_citizen_women_1_orator", 20, 20, {}),
    # Laureate F: women_citizen_women_3 → match citizen_2 (90° → 20°)
    ("chibi_women_citizen_women_3", "chibi_women_citizen_women_3_laureate", 90, 20, {}),
    # Chorister M: citizen_2 → match magician_girl_2 palette (20° → 330°)
    ("chibi_citizen_2", "chibi_citizen_2_chorister", 20, 330, {}),
    # Chorister F: magician_girl_2 → slight adjustment if needed
    ("chibi_magician_girl_2", "chibi_magician_girl_2_chorister", 330, 320, {}),
    # Herald F: winter_witch_2 → match magician_2 (30° → 20°)
    ("chibi_winter_witch_2", "chibi_winter_witch_2_herald", 30, 20, {}),
]

SCHOLAR_SWAPS = [
    # Scholar F: dark_elves_1 → match old_hero_2 (30° → 20°)
    ("chibi_dark_elves_1", "chibi_dark_elves_1_scholar", 30, 20, {}),
    # Artificer F: winter_witch_3 → match technomage_1 (190° → 20°)
    ("chibi_winter_witch_3", "chibi_winter_witch_3_artificer", 190, 20, {}),
    # Alchemist F: dark_elves_3 → match bloody_alchemist_1 (20° → 20°, already close)
    ("chibi_dark_elves_3", "chibi_dark_elves_3_alchemist", 20, 15, {}),
    # Thaumaturge F: dark_oracle_3 lighter hue
    ("chibi_dark_oracle_3", "chibi_dark_oracle_3_f",
     260, 280, {"lightness_shift": 0.08}),
    # Tinker F: women_citizen_women_2 → match gnome_1 (20° → 10°)
    ("chibi_women_citizen_women_2", "chibi_women_citizen_women_2_tinker", 20, 10, {}),
    # Bombardier F: vampire_hunter_3 → match mercenaries_2 (10° → 20°)
    ("chibi_vampire_hunter_3", "chibi_vampire_hunter_3_bombardier", 10, 20, {}),
    # Siegemaster F: valkyrie_1 → match medieval_sergeant (30° → 20°)
    ("chibi_valkyrie_1", "chibi_valkyrie_1_siegemaster", 30, 20, {}),
    # Chronomancer F: fallen_angel_s_1 → match time_keeper_2 (10° → 20°)
    ("chibi_fallen_angel_s_1", "chibi_fallen_angel_s_1_chronomancer", 10, 20, {}),
    # Cosmologist F: dark_oracle_3 → distinct from thaumaturge variant
    ("chibi_dark_oracle_3", "chibi_dark_oracle_3_cosmologist_f",
     260, 230, {"lightness_shift": 0.05}),
    # Astronomer F: hue diff
    ("chibi_old_hero_3", "chibi_old_hero_3_f", 20, 350, {"lightness_shift": 0.05}),
    # Arithmancer F: hue diff
    ("chibi_cursed_alchemist_1", "chibi_cursed_alchemist_1_f",
     220, 260, {"lightness_shift": 0.05}),
    # Automaton F: hue diff
    ("chibi_golem_1", "chibi_golem_1_f", 190, 150, {"lightness_shift": 0.05}),
    # Technomancer F: hue diff
    ("chibi_technomage_2", "chibi_technomage_2_f", 210, 250, {"lightness_shift": 0.05}),
]

STRANGER_SWAPS = [
    # Neutral stranger: red eyes → blue, slight lighten for "mysterious traveler" look
    ("chibi_black_reaper_1", "chibi_black_reaper_1_neutral", 0, 220,
     {"hue_tolerance": 60, "sat_min": 0.08, "lightness_shift": 0.08}),
]

ALL_TREES = {
    "squire": SQUIRE_SWAPS + ROYAL_SWAPS,
    "mage": MAGE_SWAPS,
    "entertainer": ENTERTAINER_SWAPS,
    "scholar": SCHOLAR_SWAPS,
    "stranger": STRANGER_SWAPS,
}


def run_swap(source_id: str, output_id: str, from_hue: float, to_hue: float,
             dry_run: bool = False, **kwargs) -> bool:
    """Run a single palette swap for all 5 animations."""
    source_dir = PROCESSED_DIR / source_id
    output_dir = PROCESSED_DIR / output_id

    if not source_dir.exists():
        print(f"  SKIP {source_id} → {output_id}: source not found")
        return False

    if dry_run:
        print(f"  [DRY] {source_id} → {output_id} ({from_hue}° → {to_hue}°)")
        return True

    output_dir.mkdir(parents=True, exist_ok=True)

    # If from_hue == to_hue and no shifts, just copy
    no_shift = (abs(from_hue - to_hue) < 1 and
                abs(kwargs.get("lightness_shift", 0)) < 0.001 and
                abs(kwargs.get("saturation_shift", 0)) < 0.001)

    for anim in ANIMS:
        src_path = source_dir / f"{anim}.png"
        dst_path = output_dir / f"{anim}.png"
        if not src_path.exists():
            continue

        if no_shift:
            shutil.copy2(src_path, dst_path)
        else:
            img = Image.open(src_path)
            result = recolor_image(
                img,
                from_hue=from_hue,
                to_hue=to_hue,
                hue_tolerance=kwargs.get("hue_tolerance", 60.0),
                sat_min=kwargs.get("sat_min", 0.15),
                lightness_shift=kwargs.get("lightness_shift", 0.0),
                saturation_shift=kwargs.get("saturation_shift", 0.0),
            )
            result.save(dst_path)

    print(f"  OK   {source_id} → {output_id} ({from_hue}° → {to_hue}°)")
    return True


def main() -> None:
    parser = argparse.ArgumentParser(description="Batch palette swaps for sprite reassignment.")
    parser.add_argument("--tree", choices=["squire", "mage", "entertainer", "scholar", "all"],
                        default="all", help="Which tree to process")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done")
    args = parser.parse_args()

    trees = [args.tree] if args.tree != "all" else list(ALL_TREES.keys())

    total = 0
    ok = 0
    for tree in trees:
        swaps = ALL_TREES[tree]
        print(f"\n{'='*60}")
        print(f"  {tree.upper()} TREE ({len(swaps)} swaps)")
        print(f"{'='*60}")
        for source_id, output_id, from_hue, to_hue, kwargs in swaps:
            total += 1
            if run_swap(source_id, output_id, from_hue, to_hue, args.dry_run, **kwargs):
                ok += 1

    print(f"\nDone: {ok}/{total} swaps processed")


if __name__ == "__main__":
    main()
