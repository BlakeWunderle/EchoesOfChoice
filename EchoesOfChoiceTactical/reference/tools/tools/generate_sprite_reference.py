#!/usr/bin/env python3
"""
Generate sprite reference materials:
  1. Markdown file with all class/enemy descriptions and current sprite assignments
  2. PNG catalog of ALL available Chibi sprites (every variant in every pack)
  3. PNG catalog of ALL available Tiny Fantasy sprites

Usage:
    python tools/generate_sprite_reference.py              # all three outputs
    python tools/generate_sprite_reference.py --docs-only  # just the markdown
    python tools/generate_sprite_reference.py --png-only   # just the catalogs
"""

import argparse
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
CLASSES_DIR = PROJECT_DIR / "resources" / "classes"
ENEMIES_DIR = PROJECT_DIR / "resources" / "enemies"
CHIBI_DIR = PROJECT_DIR / "assets" / "art" / "sprites" / "characters" / "chibi"
TINY_DIR = PROJECT_DIR / "assets" / "art" / "sprites" / "characters" / "tiny"

# Import sprite mappings
sys.path.insert(0, str(SCRIPT_DIR))
from set_sprite_ids import CLASS_SPRITE_IDS, CLASS_SPRITE_IDS_FEMALE, ENEMY_SPRITE_IDS

# Visual constants
THUMB = 80
CELL_PAD = 4
LABEL_H = 28  # two lines of text
BG = (32, 32, 42)
TEXT_COL = (210, 210, 210)
ACCENT = (255, 200, 80)
ASSIGNED_BORDER = (100, 255, 100)
UNASSIGNED_BORDER = (80, 80, 100)

SKIP_DIRS = {"__MACOSX", ".DS_Store", "AI", "EPS", "TXT", "Unity Package", "Prev",
             "Vector Parts", "license.txt", "readme.txt"}


def try_font(size: int = 11):
    for fp in ["C:/Windows/Fonts/consola.ttf", "C:/Windows/Fonts/arial.ttf"]:
        try:
            return ImageFont.truetype(fp, size)
        except (OSError, IOError):
            continue
    return ImageFont.load_default()


# ---------------------------------------------------------------------------
# .tres parser
# ---------------------------------------------------------------------------

def parse_tres(path: Path) -> dict:
    """Extract key fields from a FighterData .tres file."""
    data = {"file": path.stem}
    text = path.read_text(encoding="utf-8", errors="replace")

    # Simple key = value extraction
    patterns = {
        "display_name": r'display_name\s*=\s*"([^"]*)"',
        "tier": r"tier\s*=\s*(\d+)",
        "base_hp": r"base_hp\s*=\s*(\d+)",
        "max_mana": r"max_mana\s*=\s*(\d+)",
        "physical_attack": r"physical_attack\s*=\s*(\d+)",
        "physical_defense": r"physical_defense\s*=\s*(\d+)",
        "magic_attack": r"magic_attack\s*=\s*(\d+)",
        "magic_defense": r"magic_defense\s*=\s*(\d+)",
        "speed": r"speed\s*=\s*(\d+)",
        "movement": r"movement\s*=\s*(\d+)",
        "jump": r"jump\s*=\s*(\d+)",
        "crit_chance": r"crit_chance\s*=\s*(\d+)",
        "dodge_chance": r"dodge_chance\s*=\s*(\d+)",
        "sprite_id": r'sprite_id\s*=\s*"([^"]*)"',
        "level": r"level\s*=\s*(\d+)",
    }
    for key, pat in patterns.items():
        m = re.search(pat, text)
        if m:
            data[key] = m.group(1)

    # Abilities (array of ExtResource paths)
    abilities = re.findall(r'res://resources/abilities/(\w+)\.tres', text)
    data["abilities"] = abilities

    # Reactions
    reactions = re.findall(r'ReactionType\.(\w+)', text)
    data["reactions"] = reactions

    # Upgrade options
    upgrades = re.findall(r'res://resources/classes/(\w+)\.tres', text)
    data["upgrades"] = upgrades

    return data


def stat_line(d: dict) -> str:
    hp = d.get("base_hp", "?")
    mp = d.get("max_mana", "?")
    patk = d.get("physical_attack", "?")
    pdef = d.get("physical_defense", "?")
    matk = d.get("magic_attack", "?")
    mdef = d.get("magic_defense", "?")
    spd = d.get("speed", "?")
    mov = d.get("movement", "?")
    jmp = d.get("jump", "?")
    crit = d.get("crit_chance", "0")
    dodge = d.get("dodge_chance", "0")
    line = f"HP {hp} | MP {mp} | PAtk {patk} | PDef {pdef} | MAtk {matk} | MDef {mdef} | Spd {spd} | Mov {mov} | Jump {jmp}"
    extras = []
    if crit != "0":
        extras.append(f"Crit {crit}%")
    if dodge != "0":
        extras.append(f"Dodge {dodge}%")
    if extras:
        line += " | " + ", ".join(extras)
    return line


def role_tag(d: dict) -> str:
    """Infer a battle role from stats and abilities."""
    patk = int(d.get("physical_attack", 0))
    pdef = int(d.get("physical_defense", 0))
    matk = int(d.get("magic_attack", 0))
    hp = int(d.get("base_hp", 0))
    spd = int(d.get("speed", 0))
    mov = int(d.get("movement", 0))
    abilities = d.get("abilities", [])
    reactions = d.get("reactions", [])

    has_heal = any("heal" in a or "mend" in a or "restoration" in a or "cure" in a
                    or "rejuvenat" in a or "soothe" in a for a in abilities)
    has_buff = any("buff" in a or "encourage" in a or "inspire" in a or "haste" in a
                   or "guard" in a or "protect" in a or "bolster" in a or "rally" in a for a in abilities)
    has_terrain = any("wall" in a or "terrain" in a or "ice_wall" in a for a in abilities)
    is_tank = "BODYGUARD" in reactions or "DAMAGE_MITIGATION" in reactions
    is_healer = "REACTIVE_HEAL" in reactions

    tags = []
    if is_tank or (pdef >= 20 and hp >= 55):
        tags.append("Tank")
    if is_healer or has_heal:
        tags.append("Healer")
    if matk > patk and matk >= 18:
        tags.append("Caster")
    elif patk >= 18:
        tags.append("Melee DPS" if mov <= 4 else "Mobile DPS")
    if has_buff:
        tags.append("Support")
    if has_terrain:
        tags.append("Terrain")
    if spd >= 16:
        tags.append("Fast")
    if mov >= 5:
        tags.append("Mobile")
    if not tags:
        if matk > patk:
            tags.append("Caster")
        else:
            tags.append("Fighter")
    return ", ".join(tags)


def appearance_note(name: str) -> str:
    """Brief description of what the character should look like thematically."""
    notes = {
        # --- Player classes ---
        "martial_artist": "Bare-fisted fighter in light robes or wraps",
        "monk": "Disciplined martial artist in monk robes, prayer beads",
        "dervish": "Fast whirling dancer with curved blade, flowing garments",
        "mercenary": "Hired sword in practical leather armor, weapon for pay",
        "hunter": "Wilderness tracker with bow, earth-toned cloak",
        "tempest": "Storm warrior crackling with energy, wind-swept",
        "ninja": "Dark-clad assassin, masked, throwing stars",
        "duelist": "Elegant swordsman with rapier, precise stance",
        "dragoon": "Armored lancer with spear, knight-like heavy gear",
        "ranger": "Bow-wielding woodsman in green/brown, hooded",
        "squire": "Young knight in basic plate armor, sword and shield",
        "knight": "Fully armored knight in heavy plate, great shield",
        "paladin": "Holy warrior in white/gold plate, radiant",
        "warden": "Heavy defensive fighter, tower shield, fortress stance",
        "bastion": "Immovable fortress in maximum plate armor, huge shield",
        "cavalry": "Mounted heavy knight, lance, commander bearing",
        "firebrand": "Fire-aspected hybrid fighter, flames and blade",
        "mage": "Classic robed caster with staff, arcane energy",
        "acolyte": "Junior healer in simple white/blue robes",
        "herald": "Magical herald in ceremonial mage robes, glowing sigils",
        "mistweaver": "Fog/mist mage in dark flowing robes, obscured",
        "stormcaller": "Storm mage with lightning motifs, crackling staff",
        "priest": "Holy caster in white vestments, divine glow",
        "thaumaturge": "Advanced mage in ornate robes, powerful aura",
        "illusionist": "Trickster mage in shifting colors, mirrors/smoke",
        "chronomancer": "Time mage with clock/hourglass motifs, aged look",
        "pyromancer": "Fire mage in red/orange robes, flames dancing",
        "cryomancer": "Ice mage in blue/white, frost crystals, cold aura",
        "electromancer": "Lightning mage with sparking staff, stormy look",
        "hydromancer": "Water mage in blue/aqua robes, flowing water motifs",
        "geomancer": "Earth mage in brown/green, stone/crystal staff",
        "entertainer": "Humble performer in colorful civilian clothes",
        "bard": "Wandering musician with instrument, traveler's garb",
        "chorister": "Choir singer in formal religious vestments",
        "orator": "Well-dressed speechmaker, noble civilian attire",
        "minstrel": "Traveling musician in road-worn colorful clothes",
        "elegist": "Melancholic poet in dark mysterious robes",
        "laureate": "Acclaimed poet in fine noble clothes, quill",
        "mime": "Silent performer in black/white, masked",
        "muse": "Inspiring artist in bright creative clothes",
        "warcrier": "Battle shouter in warrior gear, horned helm, fierce",
        "scholar": "Robed academic with books, spectacles, aged wisdom",
        "alchemist": "Potion maker with vials, stained apron, goggles",
        "artificer": "Magical crafter with tools, mechanical parts",
        "tinker": "Small inventor with gadgets, goggles, wrench",
        "technomancer": "Tech-magic hybrid in steampunk-ish gear",
        "bombardier": "Explosives expert with bombs, heavy pack",
        "siegemaster": "Heavy military engineer, fortification gear",
        "automaton": "Golem/construct body, mechanical, gem core",
        "astronomer": "Stargazer in robes with telescope, celestial patterns",
        "cosmologist": "Cosmic scholar with dimensional/space motifs",
        "arithmancer": "Math mage with glowing equations, analytical look",
        "prince": "Armored royal with crown, regal bearing, gold/blue",
        "princess": "Warrior princess with tiara, elegant yet battle-ready",
        # --- Enemies ---
        "goblin": "Small green-skinned humanoid with crude dagger",
        "goblin_archer": "Goblin with shortbow, sneaky posture",
        "goblin_shaman": "Goblin with staff, tribal paint, magic glow",
        "hobgoblin": "Larger, more disciplined goblin in better armor",
        "wolf": "Gray/black wolf, snarling, four-legged canine",
        "shadow_hound": "Spectral dark wolf, glowing eyes, shadowy",
        "wild_boar": "Tusked charging beast, bristly, bulky",
        "bear": "Large brown/black bear, standing, claws bared",
        "bear_cub": "Smaller bear, less threatening but still clawed",
        "night_prowler": "Stealthy dark humanoid predator, glowing eyes",
        "dusk_prowler": "Twilight-hunting shadowy figure",
        "dread_stalker": "Elite dark hunter, menacing presence",
        "cave_bat": "Flying bat creature, leathery wings",
        "thug": "Rough street criminal with club or knife",
        "street_tough": "Muscular gang enforcer, scarred, brass knuckles",
        "hex_peddler": "Shady dark merchant selling cursed goods",
        "guard_squire": "Royal guard in official knight armor",
        "elite_guard_squire": "Elite royal guard, finer armor with insignia",
        "guard_mage": "Royal court mage in official blue robes",
        "elite_guard_mage": "Senior court mage with powerful staff",
        "guard_scholar": "Royal advisor in purple scholarly robes",
        "guard_entertainer": "Court herald/performer in civilian garb",
        "commander": "Heavily armored military commander, gold trim",
        "captain": "Pirate captain with tricorne, sword, coat",
        "pirate": "Seafaring raider with cutlass, bandana",
        "imp": "Tiny red-skinned demon, mischievous, wings",
        "fiendling": "Small blood-red demon, claws and fangs",
        "fire_spirit": "Floating fire creature, ember body",
        "cave_bat": "Winged cave-dwelling creature",
        "pixie": "Tiny glowing fairy with wings, nature magic",
        "sprite": "Small forest spirit, leafy, green glow",
        "wisp": "Floating ball of ghostly light",
        "satyr": "Goat-legged fey with pipes, forest dweller",
        "nymph": "Beautiful nature spirit, bow, graceful",
        "tide_nymph": "Ocean variant nymph, blue/aqua, water motifs",
        "siren": "Aquatic enchantress with serpentine features",
        "chanteuse": "Fey performer with magical voice",
        "shade": "Dark ghostly figure, floating, drain magic",
        "dire_shade": "Larger more dangerous dark ghost",
        "wraith": "Spectral undead in tattered armor, glowing",
        "grave_wraith": "Cemetery-bound wraith, gravestones",
        "dread_wraith": "Powerful wraith with fear aura",
        "specter": "Translucent floating ghost, chilling presence",
        "phantom_prowler": "Ghost that hunts the living, predatory",
        "mirror_stalker": "Reflective phantom, mirrors, illusions",
        "witch": "Skeleton witch with staff, dark magic",
        "elder_witch": "Powerful senior witch, more ornate",
        "necromancer": "Death mage in black robes, skulls, undead minions",
        "warlock": "Dark pact caster, demonic symbols",
        "psion": "Psychic undead mage, mind powers, eerie glow",
        "chaplain": "Undead holy figure, corrupted vestments",
        "shaman": "Nature-magic undead, tribal, bone totems",
        "runewright": "Undead rune caster, glowing rune symbols",
        "zombie": "Shambling undead villager, torn clothes",
        "bone_sentry": "Skeletal guard with sword and shield",
        "cursed_peddler": "Undead merchant, rotting noble clothes",
        "fire_wyrmling": "Young fire dragon, small, flaming breath",
        "frost_wyrmling": "Young ice dragon, icy blue, frost breath",
        "gloom_stalker": "Dark dragon hatchling, shadow wings",
        "arc_golem": "Electrical construct, sparking, stone/metal body",
        "ironclad": "Heavy iron golem, massive, slow, powerful",
        "android": "Mechanical humanoid, artificial, precise",
        "machinist": "Animated machine operator, gears and tools",
        "hellion": "Lesser demon, horns, fire, aggressive",
        "arch_hellion": "Greater demon in dark armor, massive presence",
        "draconian": "Dragon-descended humanoid fiend, scales and wings",
        "ringmaster": "Carnival demon, skull-faced, whip and tricks",
        "harlequin": "Trickster demon with pumpkin head, chaotic",
        "watcher_lord": "Multi-eyed observer entity, tentacles",
        "void_watcher": "Cosmic watching entity, dark void motifs",
        "seraph": "Corrupted angel with tattered wings",
        "dusk_moth": "Large moth-like creature of twilight",
        "twilight_moth": "Evening moth creature, luminous wings",
        "fire_elemental": "Pure fire entity, humanoid flame shape",
        "water_elemental": "Pure water entity, flowing liquid form",
        "air_elemental": "Pure air entity, swirling wind/cloud form",
        "earth_elemental": "Pure earth entity, rock/crystal humanoid",
        "kraken": "Massive tentacled sea beast, boss-sized",
        "the_stranger": "Mysterious dark reaper figure, final boss, ominous",
    }
    return notes.get(name, "")


# ---------------------------------------------------------------------------
# Markdown generation
# ---------------------------------------------------------------------------

def generate_docs(output_path: Path) -> None:
    """Generate the class/enemy reference markdown."""
    lines = ["# Sprite Reference — Classes & Enemies\n"]
    lines.append("Current sprite assignments with stats, abilities, and visual notes.")
    lines.append("Use this alongside the sprite catalog PNGs to evaluate assignments.\n")

    # --- Player Classes ---
    lines.append("## Player Classes (54)\n")

    # Group by tree — 4 base (T0) classes, each with 4 T1 branches, each with 2 T2 upgrades
    trees = {
        "Squire Tree": [
            "squire",
            # Duelist branch
            "duelist", "cavalry", "dragoon",
            # Ranger branch
            "ranger", "mercenary", "hunter",
            # Warden branch
            "warden", "knight", "bastion",
            # Martial Artist branch
            "martial_artist", "ninja", "monk"],
        "Mage Tree": [
            "mage",
            # Mistweaver branch
            "mistweaver", "cryomancer", "hydromancer",
            # Firebrand branch
            "firebrand", "pyromancer", "geomancer",
            # Stormcaller branch
            "stormcaller", "electromancer", "tempest",
            # Acolyte branch
            "acolyte", "paladin", "priest"],
        "Entertainer Tree": [
            "entertainer",
            # Bard branch
            "bard", "warcrier", "minstrel",
            # Dervish branch
            "dervish", "illusionist", "mime",
            # Orator branch
            "orator", "laureate", "elegist",
            # Chorister branch
            "chorister", "herald", "muse"],
        "Scholar Tree": [
            "scholar",
            # Artificer branch
            "artificer", "alchemist", "thaumaturge",
            # Tinker branch
            "tinker", "bombardier", "siegemaster",
            # Cosmologist branch
            "cosmologist", "astronomer", "chronomancer",
            # Arithmancer branch
            "arithmancer", "automaton", "technomancer"],
        "Royal": ["prince", "princess"],
    }

    for tree_name, class_list in trees.items():
        lines.append(f"### {tree_name}\n")
        for cls in class_list:
            tres_path = CLASSES_DIR / f"{cls}.tres"
            if not tres_path.exists():
                continue
            d = parse_tres(tres_path)
            name = d.get("display_name", cls.replace("_", " ").title())
            tier = d.get("tier", "?")
            sprite = CLASS_SPRITE_IDS.get(cls, "???")
            fem_sprite = CLASS_SPRITE_IDS_FEMALE.get(cls, "")
            role = role_tag(d)
            note = appearance_note(cls)

            lines.append(f"**{name}** (Tier {tier}) — {role}")
            lines.append(f"- Sprite: `{sprite}`" + (f" | Female: `{fem_sprite}`" if fem_sprite else ""))
            lines.append(f"- {stat_line(d)}")
            if d["abilities"]:
                lines.append(f"- Abilities: {', '.join(d['abilities'])}")
            if d["reactions"]:
                lines.append(f"- Reactions: {', '.join(d['reactions'])}")
            if d["upgrades"]:
                lines.append(f"- Upgrades to: {', '.join(d['upgrades'])}")
            if note:
                lines.append(f"- Should look like: {note}")
            lines.append("")

    # --- Enemies ---
    lines.append("## Enemies (78)\n")

    enemy_groups = {
        "Goblinoid": ["goblin", "goblin_archer", "goblin_shaman", "hobgoblin"],
        "Beasts & Prowlers": ["wolf", "shadow_hound", "wild_boar", "bear", "bear_cub",
                               "night_prowler", "dusk_prowler", "dread_stalker", "cave_bat"],
        "City Thugs": ["thug", "street_tough", "hex_peddler"],
        "Guards & Military": ["guard_squire", "elite_guard_squire", "guard_mage",
                               "elite_guard_mage", "guard_scholar", "guard_entertainer",
                               "commander", "captain", "pirate"],
        "Imps & Small Demons": ["imp", "fiendling", "fire_spirit"],
        "Nature Spirits": ["pixie", "sprite", "wisp"],
        "Nature / Fey Humanoids": ["satyr", "nymph", "tide_nymph", "siren", "chanteuse"],
        "Spectral": ["shade", "dire_shade", "wraith", "grave_wraith", "dread_wraith",
                      "specter", "phantom_prowler", "mirror_stalker"],
        "Undead Casters": ["witch", "elder_witch", "necromancer", "warlock", "psion",
                           "chaplain", "shaman", "runewright"],
        "Undead Melee": ["zombie", "bone_sentry", "cursed_peddler"],
        "Wyrmlings": ["fire_wyrmling", "frost_wyrmling", "gloom_stalker"],
        "Constructs": ["arc_golem", "ironclad", "android", "machinist"],
        "Demons": ["hellion", "arch_hellion", "draconian", "ringmaster", "harlequin"],
        "Watchers & Moths": ["watcher_lord", "void_watcher", "seraph", "dusk_moth", "twilight_moth"],
        "True Elementals (Prog 7)": ["fire_elemental", "water_elemental", "air_elemental", "earth_elemental"],
        "Bosses": ["kraken", "the_stranger"],
    }

    for group_name, enemy_list in enemy_groups.items():
        lines.append(f"### {group_name}\n")
        for enemy in enemy_list:
            tres_path = ENEMIES_DIR / f"{enemy}.tres"
            if not tres_path.exists():
                continue
            d = parse_tres(tres_path)
            name = d.get("display_name", enemy.replace("_", " ").title())
            level = d.get("level", "?")
            sprite = ENEMY_SPRITE_IDS.get(enemy, "???")
            role = role_tag(d)
            note = appearance_note(enemy)

            lines.append(f"**{name}** (Lv {level}) — {role}")
            lines.append(f"- Sprite: `{sprite}`")
            lines.append(f"- {stat_line(d)}")
            if d["abilities"]:
                lines.append(f"- Abilities: {', '.join(d['abilities'])}")
            if note:
                lines.append(f"- Should look like: {note}")
            lines.append("")

    output_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Docs written: {output_path}")


# ---------------------------------------------------------------------------
# Sprite catalog PNG generation
# ---------------------------------------------------------------------------

def find_idle_frame(variant_dir: Path) -> Path | None:
    """Find the first idle frame PNG in a CraftPix variant directory."""
    # CraftPix structure: variant/PNG/PNG Sequences/Idle/frame_000.png
    png_dir = variant_dir / "PNG" / "PNG Sequences" / "Idle"
    if not png_dir.exists():
        # Try alternate names
        for alt in ["Idle Blinking", "Walking"]:
            png_dir = variant_dir / "PNG" / "PNG Sequences" / alt
            if png_dir.exists():
                break
        else:
            return None

    frames = sorted(png_dir.glob("*.png"))
    return frames[0] if frames else None


def load_thumbnail(frame_path: Path, size: int = THUMB) -> Image.Image | None:
    """Load a sprite frame and resize to thumbnail."""
    try:
        img = Image.open(frame_path).convert("RGBA")
        # Fit to square while preserving aspect ratio
        img.thumbnail((size, size), Image.LANCZOS)
        # Center on transparent square
        result = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        x = (size - img.width) // 2
        y = (size - img.height) // 2
        result.paste(img, (x, y), img)
        return result
    except Exception:
        return None


def get_all_assigned() -> set[str]:
    """Get set of all currently assigned sprite IDs."""
    assigned = set(CLASS_SPRITE_IDS.values())
    assigned.update(CLASS_SPRITE_IDS_FEMALE.values())
    assigned.update(ENEMY_SPRITE_IDS.values())
    return assigned


def generate_catalog(collection_dir: Path, collection_name: str, output_path: Path,
                     cols: int = 12) -> None:
    """Generate a contact sheet PNG for all sprites in a collection."""
    assigned = get_all_assigned()

    # Gather all variants
    entries: list[tuple[str, str, Path]] = []  # (pack, variant, idle_frame_path)

    if not collection_dir.exists():
        print(f"  Collection dir not found: {collection_dir}")
        return

    for pack_dir in sorted(collection_dir.iterdir()):
        if not pack_dir.is_dir() or pack_dir.name in SKIP_DIRS:
            continue
        pack_name = pack_dir.name

        # Check for variant subdirectories (exclude non-character dirs)
        variant_dirs = []
        for child in sorted(pack_dir.iterdir()):
            if not child.is_dir() or child.name in SKIP_DIRS:
                continue
            # Check if this looks like a variant (has PNG subdir)
            if (child / "PNG").exists():
                variant_dirs.append(child)

        if not variant_dirs:
            # Tiny Fantasy layout: pack/PNG/VariantName/PNG Sequences/...
            png_root = pack_dir / "PNG"
            if png_root.exists():
                for child in sorted(png_root.iterdir()):
                    if not child.is_dir() or child.name in SKIP_DIRS:
                        continue
                    # Check if it has PNG Sequences inside
                    if (child / "PNG Sequences").exists():
                        variant_dirs.append(child)
                if not variant_dirs:
                    # Single variant: pack/PNG/PNG Sequences/...
                    if (png_root / "PNG Sequences").exists():
                        variant_dirs = [pack_dir]

        for vdir in variant_dirs:
            frame = find_idle_frame(vdir)
            if not frame:
                # Tiny Fantasy: variant is inside PNG/ already, try direct path
                seq_dir = vdir / "PNG Sequences" / "Idle"
                if seq_dir.exists():
                    frames = sorted(seq_dir.glob("*.png"))
                    if frames:
                        frame = frames[0]
            if frame:
                entries.append((pack_name, vdir.name, frame))

    if not entries:
        print(f"  No sprites found in {collection_dir}")
        return

    print(f"  Found {len(entries)} sprites in {collection_name}")

    # Calculate layout
    cell_w = THUMB + CELL_PAD * 2
    cell_h = THUMB + LABEL_H + CELL_PAD * 2
    rows = (len(entries) + cols - 1) // cols
    img_w = cols * cell_w + CELL_PAD
    img_h = rows * cell_h + CELL_PAD

    img = Image.new("RGBA", (img_w, img_h), BG)
    draw = ImageDraw.Draw(img)
    font = try_font(9)
    font_small = try_font(8)

    # Build a mapping to check if a sprite is assigned
    # For chibi, the sprite_id is derived from pack + variant name
    # We'll just show pack/variant labels and border color for assigned

    for i, (pack, variant, frame_path) in enumerate(entries):
        col = i % cols
        row = i // cols
        x = col * cell_w + CELL_PAD
        y = row * cell_h + CELL_PAD

        # Draw labels (pack on top, variant below)
        pack_label = pack[:16]
        var_label = variant[:16] if variant != pack else ""
        draw.text((x + 2, y), pack_label, fill=ACCENT, font=font_small)
        if var_label:
            draw.text((x + 2, y + 11), var_label, fill=TEXT_COL, font=font_small)

        # Draw sprite thumbnail
        sprite_y = y + LABEL_H
        thumb = load_thumbnail(frame_path)
        if thumb:
            img.paste(thumb, (x + CELL_PAD, sprite_y), thumb)

        # Border: green if assigned, gray if available
        # Check if this sprite is assigned by trying to match the sprite_id pattern
        # This is approximate — checks if any assigned ID contains the pack name
        is_used = False
        pack_lower = pack.lower()
        var_lower = variant.lower().replace(" ", "_")
        for sid in assigned:
            if pack_lower in sid and (var_lower in sid or variant == pack):
                is_used = True
                break

        border_col = ASSIGNED_BORDER if is_used else UNASSIGNED_BORDER
        draw.rectangle(
            [x + CELL_PAD - 1, sprite_y - 1,
             x + CELL_PAD + THUMB, sprite_y + THUMB],
            outline=border_col, width=1
        )

    img.save(output_path)
    print(f"  Catalog saved: {output_path} ({img_w}x{img_h})")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--docs-only", action="store_true")
    parser.add_argument("--png-only", action="store_true")
    args = parser.parse_args()

    do_docs = not args.png_only
    do_png = not args.docs_only

    if do_docs:
        print("Generating class/enemy reference docs...")
        generate_docs(PROJECT_DIR / "sprite_reference.md")

    if do_png:
        print("Generating Chibi sprite catalog...")
        generate_catalog(CHIBI_DIR, "Chibi", PROJECT_DIR / "catalog_chibi.png", cols=12)

        print("Generating Tiny Fantasy sprite catalog...")
        generate_catalog(TINY_DIR, "Tiny Fantasy", PROJECT_DIR / "catalog_tiny_fantasy.png", cols=12)


if __name__ == "__main__":
    main()
