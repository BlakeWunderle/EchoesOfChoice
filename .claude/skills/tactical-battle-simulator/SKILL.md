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

## What the Tool Does NOT Check

- Actual win rates (requires a full battle simulator — not yet built)
- Grid positioning advantage/disadvantage
- Reaction trigger frequency
- AoE ability multi-target value
- Mana economy (ability usage frequency)
- Player composition variance (all checks use fixed defense profiles)

---

## Full Battle Simulator (Not Yet Built)

When the automated simulator is built, it should:

1. Instantiate a battle from a `BattleConfig`
2. Run all units as AI (player units use enemy AI decision logic)
3. Resolve the battle to completion
4. Record win/loss and per-unit stats
5. Repeat N times per party composition
6. Report aggregate win rates

### Key Differences from C# Simulator

| Aspect | C# Game | Tactical Game |
|--------|---------|---------------|
| Party size | 3 | 5 (player + 4 guards) |
| Combat system | Turn-based text | Grid-based tactical |
| Enemy data | C# constructors | `.tres` FighterData resources |
| Level system | Auto-level | XP-based with catch-up |

### Party Composition Space

56 unique compositions at Tier 0 (multisets of 5 from 4 base classes). Expands greatly at Tier 1/2.

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

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/tools/balance_check.gd` | **Static analysis tool — primary balance check** |
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
