---
name: item-balance
description: Check if equipment items are balanced in EchoesOfChoiceTactical. Use when items feel too strong or weak, when building a new item set, after changing item stat values, or when you want to know which class benefits most from an item. Runs a mirror-fight static analysis via item_check.gd.
---

# Equipment Item Balance Checker

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoiceTactical/`.

## What It Does

`tools/item_check.gd` runs a **mirror-fight static analysis** for every equipment item. It takes the same class twice (equipped unit A vs bare unit B), applies one item to unit A, and measures the combat delta:

- **Dmg** = damage A deals to B per basic attack
- **TTK** = hits for A to kill B (∞ = cannot)
- **TTS** = hits for B to kill A (∞ = cannot / immune)
- **ΔKill** = `baseline_TTK − TTK` (positive = kills faster)
- **ΔSurv** = `TTS − baseline_TTS` (positive = survives longer)

Reference classes tested: **Squire** (physical), **Mage** (magical), **Scholar** (magic-defensive). Tier checkpoints: T0 → Lv2, T1 → Lv4, T2 → Lv6.

Items are grouped: Tier 0, Tier 1, Tier 2 (by `unlock_tier`), plus a Story/Unique section for free items (`buy_price = 0`).

A **combo section** runs preset 2-slot and 3-slot loadouts at T2 to catch stacking issues.

---

## How to Run

```
"C:\Users\blake\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.6.1-stable_win64_console.exe" --path EchoesOfChoiceTactical --headless --script res://tools/item_check.gd
```

**Filter options** (after `--`):

| Command | Effect |
|---------|--------|
| *(no args)* | Full discovery pass — all classes × all tiers |
| `-- squire` | Squire only (physical attacker perspective) |
| `-- mage` | Mage only (magical attacker perspective) |
| `-- scholar` | Scholar only (magic-defensive perspective) |
| `-- 0` | Tier 0 items only (all classes) |
| `-- 1` | Tier 1 items only (all classes) |
| `-- 2` | Tier 2 items only (all classes) |
| `-- squire 1` | Squire at Tier 1 only |

### Two-phase workflow

1. **First run (discovery):** Run with no filter to see all classes × all tiers. Look at which class shows non-WEAK, non-ZERO ΔKill/ΔSurv for each item group. That's the best-fit class.
2. **Subsequent runs (focused):** Use the class filter (`-- squire`, `-- mage`, etc.) to quickly re-check only the relevant archetype when tuning or adding items.

The **Canonical Best-Fit table** below records which class to use for each item type going forward.

---

## Flag Reference

| Flag | Trigger | Meaning | Fix |
|------|---------|---------|-----|
| `⚠IMMUNE` | `dmg_b = 0` (bare can no longer hurt equipped) | Defensive item makes unit immune to bare class | Reduce stat bonus by 1–2 |
| `⚠SPIKE` | `base_TTK / TTK ≥ 2.5` (kills 2.5× faster) | Offensive item too dominant | Reduce stat bonus by 2–4 |
| `⚠WEAK` | `ΔKill = 0 AND ΔSurv = 0` for a combat item | Item has no mirror-fight effect for this class | Expected for wrong-type items (M.Atk on Squire); only a problem if item is class-appropriate |
| `✓BREAK` | `base_TTK = ∞`, item makes `TTK < ∞` | Item breaks a 0-dmg degenerate mirror | Informative — see Scholar notes |
| `⚠SPIKE (combo)` | Combo TTK < 40% of baseline | 3-slot stacking is too strong | Reduce individual item stats or increase prices |
| `⚠IMMUNE (combo)` | Combo makes unit immune | Full defense stacking breaks the game | Reduce T2 defense stat bonuses |

### Scholar note

Scholar's base stats (PA ≤ PD, MA = MD) mean the **baseline mirror is always 0-dmg**. The tool prints "Baseline: 0 dmg both ways" and marks items that push past the breakpoint as `✓BREAK`. For Scholar:
- M.Atk items that break immunity = strong offensive items ✓
- P.Def, M.Def, HP items → `⚠WEAK` in mirror (still useful in real combat vs enemies)
- Use `-- scholar` to see which M.Atk threshold breaks immunity at each tier

---

## Fix Recipes

| Problem | Fix |
|---------|-----|
| `⚠IMMUNE` on a single-stat defense item | Reduce `stat_bonuses[1]` (P.Def) or `stat_bonuses[3]` (M.Def) by 1–2 |
| `⚠SPIKE` on a single-stat offense item | Reduce `stat_bonuses[0]` (P.Atk) or `stat_bonuses[2]` (M.Atk) by 2–3 |
| Story item too strong in mirror | Lower the dominant stat bonus; split into two smaller bonuses |
| `⚠IMMUNE` combo only | Raise `buy_price` on T2 defense items (reduce accessibility) or lower T2 bonus slightly |
| `⚠SPIKE` combo only | The individual items are fine; the combination is expected to be strong at 3 slots — only flag as a problem if `TTK < 5` at T2 |

---

## Canonical Best-Fit Table

*Filled in after first discovery run. Lists which reference class best represents each item type.*

| Item group | Best-fit class | Rationale |
|------------|---------------|-----------|
| P.Atk (0, 1, 2) | `squire` | Physical attacker — PA items show SPIKE/IMMUNE on Squire |
| P.Def (0, 1, 2) | `squire` | PA≈PD at base; even +3 PD causes IMMUNE → clearest signal |
| M.Atk (0, 1, 2) | `mage` | Magic attacker — MA items show SPIKE on Mage |
| M.Def (0, 1, 2) | `mage` | MA≈MD at base; +5 MD causes IMMUNE on Mage |
| HP (0, 1, 2) | `squire` | Squire has tightest HP margin; +5 HP is 1–2 extra TTS hits |
| Mana (0, 1, 2) | `mage` | Spellcaster — mana is meaningful for Mage; ⚠WEAK on all in mirror (expected) |
| Speed (0, 1, 2) | `squire` | Mirror shows % speed gain (all classes similar; Squire chosen for baseline) |
| Crit% (1, 2) | `squire` | Highest base damage → crit has largest absolute impact |
| Dodge% (1, 2) | `scholar` | Squishiest class — dodge matters most when incoming dmg is life-threatening |
| Move (1, 2) | `scholar` | Shortest base range (3 tiles) → +1 move is largest relative gain |
| Jump (1, 2) | `mage` | Lowest base jump (1) → +1 jump is a 100% increase |
| Story/Unique | varies | `_best_fit_class()` in `item_check.gd` assigns based on primary stat |

*To update: run full pass, check which class shows the most meaningful non-WEAK ΔKill/ΔSurv per item group, then edit this table.*

---

## Class-Fit Guidance

Use this when designing items or deciding which class should use an item:

| Stat boosted | Classes that benefit most | Classes where it's ⚠WEAK |
|-------------|--------------------------|--------------------------|
| P.Atk | Squire, Duelist, Knight, Cavalry, Mercenary, Monk, Paladin | Scholar, Mage (physical damage near-zero) |
| M.Atk | Mage, Firebrand, Mistweaver, Scholar, Entertainer | Squire (magic damage near-zero) |
| P.Def | Warden, Bastion, Knight, Paladin | Not WEAK — but mirror effect exaggerated at low levels |
| M.Def | Acolyte, Herald, Chronomancer, Mage | Mirror shows WEAK until MA > MD threshold |
| HP | Universal (all classes) | — |
| Mana | Mage, Scholar, Entertainer and their T1/T2 upgrades | Squire tree (few abilities) |
| Speed | Low-speed classes (Squire 13 base, Scholar 13) benefit most in % terms | High-speed classes get smaller % gain |
| Crit% | High-damage attackers (Squire tree, Cavalry, Ninja) | Low-damage supports (heal/buff classes) |
| Dodge% | Squishy low-HP units (Scholar, Mage) | Tanks (already high HP, dodge is redundant) |
| Move | Short-range classes (Scholar 3, Mage 3) | Long-range classes (Cavalry 6–7) |
| Jump | Low-jump classes (Mage 1, Acolyte 1) | High-jump classes (Ranger 3) |

---

## Item Stat Reference

Standard tiered items (shop-purchasable):

| Group | T0 (+bonus, price) | T1 (+bonus, price) | T2 (+bonus, price) |
|-------|-------------------|-------------------|-------------------|
| HP | +5, 50 | +10, 120 | +15, 250 |
| Mana | +3, 50 | +5, 120 | +8, 250 |
| P.Atk | +3, 60 | +5, 140 | +8, 280 |
| P.Def | +3, 60 | +5, 140 | +8, 280 |
| M.Atk | +3, 60 | +5, 140 | +8, 280 |
| M.Def | +3, 60 | +5, 140 | +8, 280 |
| Speed | +2, 50 | +3, 120 | +5, 260 |
| Crit% | — | +1, 80 | +2, 200 |
| Dodge% | — | +1, 80 | +2, 200 |
| Move | — | +1, 150 | +2, 300 |
| Jump | — | +1, 150 | +2, 300 |

T2 items require `unlock_tier = 2` AND a matching T2 class in the party (`unlock_class_ids`). They are hidden from the shop until the condition is met.
