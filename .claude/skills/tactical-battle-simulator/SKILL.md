---
name: tactical-battle-simulator
description: Run battle simulations for the Godot tactical game (EchoesOfChoiceTactical). Use when the user wants to simulate tactical battles, check win rates, tune enemy stats, balance combat, or verify the difficulty gradient for the 5-member party system.
---

# Tactical Battle Simulator

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoiceTactical/`.

## What Exists Today: `balance_check.gd`

A **static analysis tool** exists at `EchoesOfChoiceTactical/tools/balance_check.gd`. It reads enemy `.tres` files directly (no game loop needed) and computes:

- Damage per hit vs each party class (Squire/Mage/Scholar/Entertainer) at their Prog defense profiles
- TTK (Squire basic-attack hits to kill the enemy)
- Flags for actionable balance problems (ZERO, SPIKE, SLOW, EASY)
- T1 extreme defender checks (Warden physical tank, Acolyte magic tank)

**This is the primary balance validation tool.** Run it after every enemy stat or battle composition change.

### How to Run

```
"<godot_exe>" --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd
```

Godot executable path on dev machine:
```
C:\Users\blake\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.6.1-stable_win64_console.exe
```

Filter to a single battle:
```
"<godot_exe>" --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd -- deep_forest
```

### Output Format

```
=== PROG 2 — smoke ===
  Imp (x2)              19 │ 2p/2m  0p/4m  0p/0m  0p/0m  │   3 ✓
  Fire Spirit           24 │ 3p/7m  0p/9m  0p/5m  0p/0m  │   4 ✓
  ...
  Warden  14p/0m │ Acolyte  0p/7m
  ✓T1 — both Warden and Acolyte threatened by at least one enemy
```

Columns: `enemy_name  phys_def | Sq_p/Sq_m  Mg_p/Mg_m  Sc_p/Sc_m  En_p/En_m | TTK flag`

### Flag Reference

| Flag | Meaning | Fix |
|------|---------|-----|
| `⚠ZERO` | Deals 0 to ALL classes | Add damage ability OR raise attack stat |
| `⚠SPIKE` | Kills any class in <3 hits | Reduce attack by 3–5 |
| `⚠SLOW` | Squire needs >10 hits to kill | Reduce HP or phys_def |
| `⚠EASY` | Squire one-shots (TTK=1) | Raise HP until TTK≥2 |
| `✓` | All clear — damage present, no spikes, TTK 2–10 | — |
| `⚠T1TANK` | No enemy threatens Warden (phys tank) | Add/raise a magic attacker |
| `⚠T1MAGE` | No magic attack penetrates Acolyte M.Def | Acceptable if physical attacks do |
| `✓T1` | Both T1 extremes threatened by at least one enemy | — |

### Design-Intent Exceptions (Do NOT Fix)

These flags are expected and documented:

| Battle | Enemy | Flag | Why OK |
|--------|-------|------|--------|
| village_raid (P1) | Goblin Shaman | ⚠ZERO | Pure healer/support. Exists to heal allies. |
| smoke (P2) | — | ⚠T1MAGE | Acolyte (M.Def 26) is immune to all magic here — that's the class's purpose. |
| gate_ambush (P5) | Hex Peddler | ⚠ZERO | Pure debuffer. Exists to debuff, not deal damage. |
| return_city_3 (P6) | Guard Scholar "Nale" | ⚠ZERO | Runewright support character. Intentional. |
| return_city_3–4 (P6) | — | ⚠T1MAGE | Acolyte M.Def=35 can't be penetrated by Prog 6 magic (<31 total). Physical fodder still threatens Acolyte. |

---

## Battles Covered by balance_check.gd

The `BATTLES` dictionary in the tool covers **all Prog 0–6 battles**:

| Battle ID | Prog | Enemies |
|-----------|------|---------|
| city_street | 0 | Thug×3, Street Tough, Hex Peddler |
| forest | 1 | Bear, Bear Cub, Wolf×2, Wild Boar |
| village_raid | 1 | Goblin×2, Goblin Archer, Goblin Shaman, Hobgoblin |
| smoke | 2 | Imp×2, Fire Spirit×3 |
| deep_forest | 2 | Witch, Wisp×2, Sprite×2 |
| clearing | 2 | Satyr, Nymph×2, Pixie×2 |
| ruins | 2 | Shade×3, Wraith, Bone Sentry |
| cave | 3 | Fire Wyrmling, Frost Wyrmling, Cave Bat×2 |
| portal | 3 | Hellion×2, Fiendling×3 |
| inn_ambush | 3 | Shadow Hound×2, Night Prowler, Dusk Moth, Gloom Stalker |
| shore | 4 | Siren×3, Nymph×2 |
| beach | 4 | Pirate×3, Captain, Kraken |
| cemetery_battle | 4 | Zombie×2, Specter×2, Wraith |
| box_battle | 4 | Harlequin×2, Chanteuse×2, Ringmaster |
| army_battle | 4 | Draconian×2, Chaplain×2, Commander |
| lab_battle | 4 | Android×2, Machinist×2, Ironclad |
| mirror_battle | 5 | Void Stalker, Gloom Stalker, Night Prowler×2, Dusk Moth |
| gate_ambush | 5 | Gloom Stalker, Night Prowler×2, Hex Peddler, Dusk Moth |
| city_gate_ambush | 6 | Void Stalker, Gloom Stalker×2, Shade, Night Prowler |
| return_city_1 | 6 | Seraph, Hellion, Night Prowler×2, Gloom Stalker |
| return_city_2 | 6 | Necromancer, Witch, Shade×2, Wraith |
| return_city_3 | 6 | Psion, Guard Scholar†, Night Prowler×2, Gloom Stalker |
| return_city_4 | 6 | Warlock, Shaman, Shade×2, Void Stalker |

† Guard Scholar (Nale) is a design-intent support ZERO — see exceptions above.

**Prog 7 (Elemental shrines) not yet in tool** — use `tactical-elemental-balance` skill when those battles are ready.

---

## What balance_check.gd Does NOT Check

- Actual win rates (use the full battle simulator below)
- Grid positioning advantage/disadvantage
- Reaction trigger frequency
- AoE ability multi-target value
- Mana economy (ability usage frequency)
- Player composition variance (all checks use fixed defense profiles)

---

## Full Battle Simulator: `battle_simulator.gd`

A headless battle simulator at `tools/sim/` that runs complete tactical battles with spatial positioning, ATB turns, movement, abilities, and reactions. Tests realistic party compositions per progression stage.

### How to Run

```
"<godot_exe>" --path EchoesOfChoiceTactical --headless --script res://tools/sim/battle_simulator.gd -- [options]
```

CLI options:
```
  <battle_id>        Simulate a specific battle (e.g. city_street)
  --all              Simulate all battles
  --progression N    Simulate all battles in progression N
  --sims N           Simulations per party combo (default: 30)
  --sample N         Max party combos to sample (default: 200)
  --verbose          Show per-battle class breakdown and combo extremes
  --list             List all available battles
```

### Examples

Single battle quick check:
```
... --script res://tools/sim/battle_simulator.gd -- city_street --sims 10 --sample 20 --verbose
```

Full progression run:
```
... --script res://tools/sim/battle_simulator.gd -- --progression 2 --sims 30 --sample 200
```

All battles:
```
... --script res://tools/sim/battle_simulator.gd -- --all --sims 30
```

### Output Format

```
=== BATTLE SIMULATOR ===

  --- city_street (79.4% vs 90.0% target) ---
  WEAKEST:
      0.0%  entertainer / entertainer / entertainer / scholar / scholar
     70.0%  squire / squire / mage / entertainer / entertainer
  STRONGEST:
    100.0%  squire / squire / mage / mage / scholar
    100.0%  mage / mage / mage / mage / scholar
  CLASS BREAKDOWN:
    mage                  96.9%
    scholar               85.7%
    squire                78.3%
    entertainer           55.7%  <-- FAIL
  JP ECONOMY (avg per battle):
    entertainer          40.9 JP  (identity)
    mage                 21.0 JP  (identity)
    squire               18.2 JP  (identity)
    scholar              17.5 JP  (identity)

  SIMULATION SUMMARY
  Battle                   Win Rate   Target     Range          Status
  --------------------------------------------------------------------------
  city_street               79.4%      90.0%       87% -   93%   TOO HARD

  Passed: 0/1 | Sims/combo: 30 | Time: 92.9s

  CLASS OUTLIERS
  Battle                   Class                Win Rate   Band
  ----------------------------------------------------------------
  city_street              entertainer           55.7%     FAIL
```

### Per-Class Win Rate Banding

Each class's win rate is compared to the stage target. Bands flag outliers:

| Band | Threshold | Meaning |
|------|-----------|---------|
| FAIL | target - 25% | Class is critically underperforming |
| WARN | target - 15% | Class is underperforming |
| OK | within range | Class is balanced |
| OVER | target + tolerance + 8% | Class is overperforming |

Example at P0 (target 90%): FAIL < 65%, WARN < 75%, OK 75-101%, OVER > 101%.
Example at P4 (target 73%): FAIL < 48%, WARN < 58%, OK 58-84%, OVER > 84%.

CLASS OUTLIERS section in the summary lists all non-OK classes across all battles.

### JP Economy Tracking

The simulator tracks JP (Job Points) earned per class per battle via `XpConfig.calculate_jp()`:
- **BASE_JP = 1** per ability use
- **IDENTITY_JP = 5** if the ability matches the class's identity actions (from `XpConfig.CLASS_IDENTITY`)
- Tier 1 upgrade threshold: 50 JP, Tier 2: 100 JP

JP ECONOMY section in verbose mode shows average JP per battle with `(identity)` marker for classes with identity action bonuses. Use this to verify all classes can realistically progress through JP tiers.

### Architecture (8 files under `tools/sim/`)

| File | Purpose |
|------|---------|
| `sim_unit.gd` | Lightweight RefCounted replacement for Unit (no sprites/animations) |
| `sim_reaction_system.gd` | Adapted ReactionSystem (no SFX, duck-typed) |
| `sim_executor.gd` | Adapted AbilityExecutor (no SFX/XP, returns kill count) |
| `sim_ai.gd` | Synchronous AI for both player and enemy units |
| `sim_turn_manager.gd` | Synchronous ATB loop (speed→100 threshold, 200 round cap) |
| `party_composer.gd` | Realistic party composition generator with archetype filtering |
| `battle_stages.gd` | All 28 battle definitions with enemy rosters and targets |
| `battle_simulator.gd` | Main entry point, CLI parsing, output formatting |

### Design Decisions

- **Both sides use same AI**: Conservative baseline. Win rates reflect stat/ability balance, not AI quality.
- **Full spatial simulation**: Movement, AoE, reactions, terrain all modeled.
- **Realistic comps only**: Require at least 2 distinct archetypes. Degenerate comps (5 healers) are filtered out.
- **Reuses Grid and Combat as-is**: Both are RefCounted with no visual dependencies.

### Party Composition Space

| Progression | Tier | Pool Size | Max Combos | Realistic (filtered) |
|-------------|------|-----------|------------|---------------------|
| 0-1 | T0 | 4 classes | 56 | ~40 |
| 2-3 | T1 | 16 classes | ~4000 | sampled to 200 |
| 4-7 | T2 | 32+ classes | ~200K | sampled to 200 |

---

## Difficulty Gradient

| Stage | Target | Range | Battles |
|-------|--------|-------|---------|
| 0 | 90% | 87-93% | City Street |
| 1 | 86% | 83-89% | Forest |
| 1 (opt) | 85% | 82-88% | Village Raid |
| 2 | 81% | 78-84% | Smoke, Deep Forest, Clearing, Ruins |
| 3 | 77% | 74-80% | Cave, Portal |
| 3 (opt) | 76% | 73-79% | Inn Ambush |
| 4 | 73% | 70-76% | Shore, Beach, Cemetery, Box, Army, Lab |
| 5 | 69% | 66-72% | Mirror, Gate Ambush |
| 6 | 64% | 61-67% | City Gate Ambush, Return City 1-4 |
| 7 | ~58% | 55-61% | Elemental battles |

---

## Player Spawn Positions

Player unit placement is **hardcoded** — there is no pre-battle placement phase. Positions come from BattleConfig and are a direct balance lever.

**Default spawns** (used by most battles via `_build_party_units` and `battle_stages.gd`):
- Leader: `Vector2i(2, 3)` — front center
- Party: `Vector2i(3, 1)`, `Vector2i(3, 2)`, `Vector2i(3, 4)`, `Vector2i(3, 5)` — second column

**Tutorial** (`battle_config_prog_01.gd`): Hardcoded at x=2-3 on 8x6 grid.

**Prog 7** (`battle_stages.gd`): Custom wider spawns for 12x10+ maps (e.g. `spawn_wide`, `final_castle`).

Enemies typically spawn at x=8-9 on 10-wide maps, creating a 5-6 tile gap. Melee (movement 4, range 1) reaches in 1-2 turns; ranged (range 3) can attack immediately.

---

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/tools/balance_check.gd` | Static analysis tool — damage/TTK checks |
| `EchoesOfChoiceTactical/tools/sim/battle_simulator.gd` | **Full battle simulator — win rate testing** |
| `EchoesOfChoiceTactical/tools/sim/battle_stages.gd` | Battle definitions for simulator (28 battles) |
| `EchoesOfChoiceTactical/tools/sim/party_composer.gd` | Realistic party composition generator |
| `EchoesOfChoiceTactical/scripts/data/battle_config.gd` | Battle configurations (enemy composition, placement) |
| `EchoesOfChoiceTactical/resources/enemies/*.tres` | Enemy stat definitions |
| `EchoesOfChoiceTactical/resources/abilities/*.tres` | Ability definitions |
| `EchoesOfChoiceTactical/scripts/data/map_data.gd` | Progression stages, node connections |
| `EchoesOfChoiceTactical/scripts/data/xp_config.gd` | XP/JP constants, level-up thresholds |

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **balance-thresholds** | Reference for damage/TTK targets, party defense profiles, fix recipes |
| **tactical-balance-feedback-loop** | Full iterative balance pass for Prog 0-6 |
| **tactical-elemental-balance** | Dedicated tuning pass for Prog 7 |
| **setting-enemy-abilities** | Designing enemy ability loadouts |
| **character-stat-tuning** | Adjusting individual class/enemy stats |
