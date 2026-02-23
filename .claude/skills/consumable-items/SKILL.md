---
name: consumable-items
description: Add or tune consumable items (potions, tonics) in EchoesOfChoiceTactical. Use when creating new consumable .tres files, adjusting heal/buff values, or updating shop stock per town. Covers the three-tier potion/tonic progression (base → Greater → Superior) and how each town's shop maps to those tiers.
---

# Consumable Items

Use this skill when creating new consumable items or tuning existing ones in `EchoesOfChoiceTactical/`. Consumables are `ItemData` resources stored as `.tres` files in `resources/items/`. Shops are stocked per-town in `TOWN_SHOPS` inside `scenes/town/Town.gd`.

---

## Canonical Item Table

This is the full tiered consumable set. Items marked **EXISTS** already have `.tres` files. Items marked **NEW** need to be created.

### HP Restoratives (`consumable_effect = 0` → HEAL_HP)

| Tier | Item ID | Display Name | Heal HP | Price | Status |
|------|---------|--------------|---------|-------|--------|
| 0 | `health_potion` | Health Potion | 30 | 25g | EXISTS |
| 1 | `greater_health_potion` | Greater Health Potion | 65 | 65g | NEW |
| 2 | `superior_health_potion` | Superior Health Potion | 110 | 130g | NEW |

### MP Restoratives (`consumable_effect = 1` → RESTORE_MANA)

| Tier | Item ID | Display Name | Restore MP | Price | Status |
|------|---------|--------------|------------|-------|--------|
| 0 | `mana_potion` | Mana Potion | 20 | 25g | EXISTS |
| 1 | `greater_mana_potion` | Greater Mana Potion | 40 | 65g | NEW |
| 2 | `superior_mana_potion` | Superior Mana Potion | 70 | 130g | NEW |

### Strength Tonics (`consumable_effect = 2`, `buff_stat = 0` → P.Atk, 3 turns)

| Tier | Item ID | Display Name | Bonus | Price | Status |
|------|---------|--------------|-------|-------|--------|
| 0 | `strength_tonic` | Strength Tonic | +5 | 40g | EXISTS |
| 1 | `greater_strength_tonic` | Greater Strength Tonic | +9 | 90g | NEW |
| 2 | `superior_strength_tonic` | Superior Strength Tonic | +14 | 170g | NEW |

### Magic Tonics (`consumable_effect = 2`, `buff_stat = 2` → M.Atk, 3 turns)

| Tier | Item ID | Display Name | Bonus | Price | Status |
|------|---------|--------------|-------|-------|--------|
| 0 | `magic_tonic` | Magic Tonic | +5 | 40g | EXISTS |
| 1 | `greater_magic_tonic` | Greater Magic Tonic | +9 | 90g | NEW |
| 2 | `superior_magic_tonic` | Superior Magic Tonic | +14 | 170g | NEW |

### Guard Tonics (`consumable_effect = 2`, `buff_stat = 1` → P.Def, 3 turns)

| Tier | Item ID | Display Name | Bonus | Price | Status |
|------|---------|--------------|-------|-------|--------|
| 0 | `guard_tonic` | Guard Tonic | +5 | 40g | NEW |
| 1 | `greater_guard_tonic` | Greater Guard Tonic | +9 | 90g | NEW |
| 2 | `superior_guard_tonic` | Superior Guard Tonic | +14 | 170g | NEW |

### Special / Exclusive (not tiered, no shop stock — merchant or battle reward only)
- `phoenix_feather` — 100 HP, 400g (EXISTS, exclusive merchant)
- `elixir` — 60 MP, 300g (EXISTS, exclusive merchant)

---

## Shop Stock Per Town

Edit the `TOWN_SHOPS` const in [EchoesOfChoiceTactical/scenes/town/Town.gd](EchoesOfChoiceTactical/scenes/town/Town.gd).

```gdscript
const TOWN_SHOPS: Dictionary = {
	"forest_village": [
		# Tier 0 only — early game
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
	],
	"crossroads_inn": [
		# Tier 0 + Tier 1 — mid game
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
	],
	"gate_town": [
		# Tier 0 + Tier 1 + Tier 2 — late game
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		"superior_health_potion", "superior_mana_potion",
		"superior_strength_tonic", "superior_magic_tonic", "superior_guard_tonic",
	],
}
```

---

## .tres File Format

All consumable item files go in `EchoesOfChoiceTactical/resources/items/`. Filename = `<item_id>.tres`.

```
[gd_resource type="Resource" script_class="ItemData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/data/item_data.gd" id="1"]

[resource]
script = ExtResource("1")
item_id = "<item_id>"
display_name = "<Display Name>"
description = "<flavour text>"
item_type = 0
buy_price = <price>
sell_price_override = -1
stat_bonuses = {}
consumable_effect = <0|1|2>
consumable_value = <value>
buff_stat = <stat_int>
buff_turns = <0 or 3>
```

**`item_type`**: always `0` for consumables.

**`consumable_effect`**:
- `0` = HEAL_HP
- `1` = RESTORE_MANA
- `2` = BUFF_STAT

**`buff_stat`** (only relevant when `consumable_effect = 2`):
- `0` = PHYSICAL_ATTACK
- `1` = PHYSICAL_DEFENSE
- `2` = MAGIC_ATTACK
- `3` = MAGIC_DEFENSE
- `7` = SPEED

**`buff_turns`**: `0` for HP/MP restoratives. `3` for all tonics.

### Example — Greater Health Potion

```
[gd_resource type="Resource" script_class="ItemData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/data/item_data.gd" id="1"]

[resource]
script = ExtResource("1")
item_id = "greater_health_potion"
display_name = "Greater Health Potion"
description = "A potent restorative that heals 65 HP."
item_type = 0
buy_price = 65
sell_price_override = -1
stat_bonuses = {}
consumable_effect = 0
consumable_value = 65
buff_stat = 0
buff_turns = 0
```

### Example — Guard Tonic (Tier 0)

```
[gd_resource type="Resource" script_class="ItemData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/data/item_data.gd" id="1"]

[resource]
script = ExtResource("1")
item_id = "guard_tonic"
display_name = "Guard Tonic"
description = "A bitter brew that hardens the body, granting +5 physical defense for 3 turns."
item_type = 0
buy_price = 40
sell_price_override = -1
stat_bonuses = {}
consumable_effect = 2
consumable_value = 5
buff_stat = 1
buff_turns = 3
```

---

## Balance Guidance

HP heal values are sized to remain meaningful throughout the campaign:

| Stage | Approx party HP | Tier 0 (30) | Tier 1 (65) | Tier 2 (110) |
|-------|-----------------|-------------|-------------|--------------|
| Forest / Prog 0-1 | 40–60 | ~50–75% | — | — |
| Crossroads / Prog 3 | 70–90 | ~33–43% | ~72–93% | — |
| Gate Town / Prog 5+ | 100–140 | ~21–30% | ~46–65% | ~79–110% |

Tonic bonuses (+5/+9/+14) add roughly 10–25% of a unit's base stat, preserving value without being game-breaking at any tier. Adjust if the balance pass changes base stats significantly.

---

## Implementation Steps

1. **Create missing `.tres` files** (9 new items) in `EchoesOfChoiceTactical/resources/items/` using the format and values from the canonical table above.

2. **Update `TOWN_SHOPS`** in `EchoesOfChoiceTactical/scenes/town/Town.gd` — replace the existing dict with the tiered version above.

3. **Build** the Godot project (headless or open in editor) and confirm no import/script errors.

4. **Commit** with message `feat: add tiered consumable items and progressive shop stock`.

---

## References

- [item_data.gd](EchoesOfChoiceTactical/scripts/data/item_data.gd) — `ItemData` resource class, `ConsumableEffect` and field docs
- [enums.gd](EchoesOfChoiceTactical/scripts/data/enums.gd) — `ItemType`, `ConsumableEffect`, `StatType` enum values
- [Town.gd](EchoesOfChoiceTactical/scenes/town/Town.gd) — `TOWN_SHOPS` const (lines 33–48), `_on_shop_pressed` for how items are loaded
- [game_state.gd](EchoesOfChoiceTactical/scripts/autoload/game_state.gd) — `add_item`, `remove_item`, `get_consumables_in_inventory`
- [BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd) — `_on_item_pressed`, `_execute_item` (how consumables are used in battle)
- Existing `.tres` examples: `resources/items/health_potion.tres`, `resources/items/strength_tonic.tres`
