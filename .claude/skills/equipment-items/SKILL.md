---
name: equipment-items
description: Add or tune equipment items in EchoesOfChoiceTactical. Use when creating new equipment .tres files, adjusting stat bonuses, setting class-unlock restrictions, or updating shop stock per town. Covers the three-tier stat equipment progression (health/mana/phys_atk/phys_def/mag_atk/mag_def/speed), the two-tier gated items (crit, dodge, movement, jump), and the rule that top-tier items are hidden until the right T2 class is in the party.
---

# Equipment Items

Use this skill when creating or editing equipment `.tres` files or updating shop stock for equipment in `EchoesOfChoiceTactical/`. Equipment files live in `EchoesOfChoiceTactical/resources/items/equipment/`. Shop stocking and unlock filtering are controlled in `scenes/town/Town.gd`.

---

## How Unlocking Works

`GameState.is_item_unlocked(item)` in [game_state.gd](EchoesOfChoiceTactical/scripts/autoload/game_state.gd) applies two sequential checks:

1. **Tier check**: Party's highest class tier ≥ `item.unlock_tier`. A T0 party (all base classes) can only see `unlock_tier=0` items; a T2 party (at least one T2 class) can see all tiers.
2. **Class check**: If `item.unlock_class_ids` is non-empty, the party must contain at least one of those class IDs.

**Critical rule:** `unlock_class_ids` for T2 items (`unlock_tier=2`) must contain **only T2 classes**. Adding a T0/T1 class to a T2 item's list would require the player to have both a T2 class (to pass the tier check) AND that T0/T1 class still in the party at the same time — an unintended constraint.

Items with `unlock_class_ids = []` (empty) are available to any party that meets the tier requirement.

Class-locked items are **hidden entirely** from the shop — they are not shown as grayed-out. They simply don't appear until the right class is recruited.

---

## Canonical Equipment Table

### 3-Tier Items (T0 → T1 → T2)

#### HP — Max Health (stat key `10`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| health_0 | Health Ring I | +5 HP | 50g | 0 | [] |
| health_1 | Health Ring II | +10 HP | 120g | 1 | [] |
| health_2 | Health Ring III | +15 HP | 250g | 2 | [thaumaturge, siegemaster, knight, bastion] |

#### MP — Max Mana (stat key `11`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| mana_0 | Mana Charm I | +3 MP | 50g | 0 | [] |
| mana_1 | Mana Charm II | +5 MP | 120g | 1 | [] |
| mana_2 | Mana Charm III | +8 MP | 250g | 2 | [chronomancer, astronomer, cryomancer, hydromancer] |

#### Physical Attack (stat key `0`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| phys_atk_0 | Strength Band I | +3 P.Atk | 60g | 0 | [] |
| phys_atk_1 | Strength Band II | +5 P.Atk | 140g | 1 | [] |
| phys_atk_2 | Strength Band III | +8 P.Atk | 280g | 2 | [cavalry, dragoon, mercenary, hunter, ninja, monk, paladin] |

#### Physical Defense (stat key `1`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| phys_def_0 | Guardian Seal I | +3 P.Def | 60g | 0 | [] |
| phys_def_1 | Guardian Seal II | +5 P.Def | 140g | 1 | [] |
| phys_def_2 | Guardian Seal III | +8 P.Def | 280g | 2 | [knight, bastion, paladin] |

#### Magic Attack (stat key `2`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| mag_atk_0 | Focus Stone I | +3 M.Atk | 60g | 0 | [] |
| mag_atk_1 | Focus Stone II | +5 M.Atk | 140g | 1 | [] |
| mag_atk_2 | Focus Stone III | +8 M.Atk | 280g | 2 | [cryomancer, hydromancer, pyromancer, geomancer, electromancer, tempest] |

#### Magic Defense (stat key `3`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| mag_def_0 | Ward Amulet I | +3 M.Def | 60g | 0 | [] |
| mag_def_1 | Ward Amulet II | +5 M.Def | 140g | 1 | [] |
| mag_def_2 | Ward Amulet III | +8 M.Def | 280g | 2 | [priest, laureate, muse, paladin, minstrel, herald, elegist, warcrier, illusionist, mime] |

#### Speed (stat key `7`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| speed_0 | Swift Boots I | +2 Spd | 50g | 0 | [] |
| speed_1 | Swift Boots II | +3 Spd | 120g | 1 | [] |
| speed_2 | Swift Boots III | +5 Spd | 260g | 2 | [automaton, technomancer, mercenary, electromancer] |

---

### 2-Tier Items

Crit% and Dodge% are **capped at 2 tiers** — a T2 crit/dodge item would be unbalanced. Their first tier doesn't appear until mid-game (Crossroads Inn) because even small crit/dodge bonuses are powerful.

Movement and Jump are **capped at 2 tiers** — +3 Movement or +3 Jump at late game would break map design. They also have no T0 item; the first tier appears at Crossroads Inn.

#### Crit% (stat key `12`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| crit_0 | Precision Lens I | +1 Crit% | 80g | 1 | [] |
| crit_1 | Precision Lens II | +2 Crit% | 200g | 2 | [cavalry, mercenary, hunter, ninja, monk, electromancer] |

#### Dodge% (stat key `8`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| dodge_0 | Evasion Cloak I | +1 Dodge% | 80g | 1 | [] |
| dodge_1 | Evasion Cloak II | +2 Dodge% | 200g | 2 | [ninja, tempest, hunter, illusionist, pyromancer, hydromancer] |

#### Movement (stat key `14`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| movement_1 | Stride Greaves I | +1 Mov | 150g | 1 | [] |
| movement_2 | Stride Greaves II | +2 Mov | 300g | 2 | [cavalry, dragoon, alchemist] |

#### Jump (stat key `15`)

| ID | Display Name | Bonus | Price | unlock_tier | unlock_class_ids |
|----|--------------|-------|-------|-------------|------------------|
| jump_1 | Leap Bracers I | +1 Jump | 150g | 1 | [] |
| jump_2 | Leap Bracers II | +2 Jump | 300g | 2 | [dragoon, bastion, bombardier] |

---

## All 32 T2 Classes and Which Items They Unlock

Every T2 class must appear in at least one top-tier item's unlock list. Use this table when adding new top-tier items to ensure no T2 class is left uncovered.

| T2 Class | Top-Tier Item(s) |
|----------|-----------------|
| cavalry | phys_atk_2, crit_1, movement_2 |
| dragoon | phys_atk_2, movement_2, jump_2 |
| mercenary | phys_atk_2, crit_1, speed_2 |
| hunter | phys_atk_2, crit_1, dodge_1 |
| knight | phys_def_2, health_2 |
| bastion | phys_def_2, health_2, jump_2 |
| ninja | phys_atk_2, crit_1, dodge_1 |
| monk | phys_atk_2, crit_1 |
| cryomancer | mag_atk_2, mana_2 |
| hydromancer | mag_atk_2, dodge_1, mana_2 |
| pyromancer | mag_atk_2, dodge_1 |
| geomancer | mag_atk_2 |
| electromancer | mag_atk_2, crit_1, speed_2 |
| tempest | mag_atk_2, dodge_1 |
| paladin | phys_atk_2, phys_def_2, mag_def_2 |
| priest | mag_def_2 |
| warcrier | mag_def_2 |
| minstrel | mag_def_2 |
| illusionist | mag_def_2, dodge_1 |
| mime | mag_def_2 |
| laureate | mag_def_2 |
| elegist | mag_def_2 |
| herald | mag_def_2 |
| muse | mag_def_2 |
| alchemist | movement_2 |
| thaumaturge | health_2 |
| bombardier | jump_2 |
| siegemaster | health_2 |
| chronomancer | mana_2 |
| astronomer | mana_2 |
| automaton | speed_2 |
| technomancer | speed_2 |

T0/T1 classes (mage, squire, entertainer, scholar, and all 16 T1 classes) do not appear in top-tier unlock lists by design. They unlock items through the T2 class they promote into.

---

## .tres File Format

All equipment files: `EchoesOfChoiceTactical/resources/items/equipment/<item_id>.tres`

```
[gd_resource type="Resource" script_class="ItemData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/data/item_data.gd" id="1"]

[resource]
script = ExtResource("1")
item_id = "<item_id>"
display_name = "<Display Name>"
description = "<flavour text>"
item_type = 1
buy_price = <price>
sell_price_override = -1
stat_bonuses = {<int_key>: <bonus>}
unlock_tier = <0|1|2>
unlock_class_ids = PackedStringArray(["class_a", "class_b"])
consumable_effect = 0
consumable_value = 0
buff_stat = 0
buff_turns = 0
```

No class restriction: `unlock_class_ids = PackedStringArray()`

Stat key integers: `0`=P.Atk, `1`=P.Def, `2`=M.Atk, `3`=M.Def, `7`=Speed, `8`=Dodge%, `10`=Max HP, `11`=Max MP, `12`=Crit%, `14`=Movement, `15`=Jump

### Example — Speed III

```
[gd_resource type="Resource" script_class="ItemData" load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/data/item_data.gd" id="1"]

[resource]
script = ExtResource("1")
item_id = "speed_2"
display_name = "Swift Boots III"
description = "Masterwork boots that grant uncanny swiftness, adding +5 speed."
item_type = 1
buy_price = 260
sell_price_override = -1
stat_bonuses = {7: 5}
unlock_tier = 2
unlock_class_ids = PackedStringArray(["automaton", "technomancer", "mercenary", "electromancer"])
consumable_effect = 0
consumable_value = 0
buff_stat = 0
buff_turns = 0
```

---

## Shop Stocking (Town.gd)

### TOWN_SHOPS Constant

Equipment IDs use the `"equipment/<id>"` prefix so `_on_shop_pressed` resolves to `res://resources/items/equipment/<id>.tres`.

```gdscript
const TOWN_SHOPS: Dictionary = {
	"forest_village": [
		# Consumables — Tier 0
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		# Equipment — Tier 0
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
		"equipment/speed_0",
	],
	"crossroads_inn": [
		# Consumables — Tier 0+1
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		# Equipment — Tier 0+1 + first 2-tier items (crit_0/dodge_0/movement_1/jump_1
		# have unlock_tier=1 so they appear automatically once a T1 class is in party)
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0", "equipment/speed_0",
		"equipment/health_1", "equipment/mana_1",
		"equipment/phys_atk_1", "equipment/phys_def_1",
		"equipment/mag_atk_1", "equipment/mag_def_1", "equipment/speed_1",
		"equipment/crit_0", "equipment/dodge_0",
		"equipment/movement_1", "equipment/jump_1",
	],
	"gate_town": [
		# Consumables — all tiers
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		"superior_health_potion", "superior_mana_potion",
		"superior_strength_tonic", "superior_magic_tonic", "superior_guard_tonic",
		# Equipment — all tiers (T2 class-locked items hidden until right class in party)
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0", "equipment/speed_0",
		"equipment/health_1", "equipment/mana_1",
		"equipment/phys_atk_1", "equipment/phys_def_1",
		"equipment/mag_atk_1", "equipment/mag_def_1", "equipment/speed_1",
		"equipment/crit_0", "equipment/dodge_0",
		"equipment/movement_1", "equipment/jump_1",
		"equipment/health_2", "equipment/mana_2",
		"equipment/phys_atk_2", "equipment/phys_def_2",
		"equipment/mag_atk_2", "equipment/mag_def_2", "equipment/speed_2",
		"equipment/crit_1", "equipment/dodge_1",
		"equipment/movement_2", "equipment/jump_2",
	],
}
```

### `_on_shop_pressed` — Unlock Filter

Replace the item-loading loop to apply `GameState.is_item_unlocked()` for equipment items:

```gdscript
func _on_shop_pressed() -> void:
	var shop_scene := preload("res://scenes/ui/ShopUI.tscn")
	var shop: Control = shop_scene.instantiate()
	var item_ids: Array = TOWN_SHOPS.get(_town_id, [])
	var items: Array = []
	for raw_id in item_ids:
		var path := "res://resources/items/%s.tres" % raw_id
		if not ResourceLoader.exists(path):
			continue
		var item: Resource = load(path) as Resource
		if not item:
			continue
		if item.get("item_type") == 1:  # Enums.ItemType.EQUIPMENT
			if not GameState.is_item_unlocked(item):
				continue
		items.append(item)
	shop.setup(items)
	shop.shop_closed.connect(func():
		shop.queue_free()
		gold_label.text = "Gold: %d" % GameState.gold
	)
	add_child(shop)
```

The `"equipment/<id>"` prefix causes `path` to resolve as `res://resources/items/equipment/<id>.tres`, which is the correct subfolder location.

---

## Implementation Steps

1. **Create `speed_2.tres`** in `EchoesOfChoiceTactical/resources/items/equipment/` using the example above.

2. **Edit existing .tres files** — the changes below:

| File | Change |
|------|--------|
| `equipment/health_2.tres` | Add `unlock_class_ids = PackedStringArray(["thaumaturge", "siegemaster", "knight", "bastion"])` |
| `equipment/mana_2.tres` | Add `unlock_class_ids = PackedStringArray(["chronomancer", "astronomer", "cryomancer", "hydromancer"])` |
| `equipment/crit_0.tres` | Change `unlock_tier = 0` → `unlock_tier = 1` |
| `equipment/crit_1.tres` | Change `unlock_tier = 1` → `unlock_tier = 2` (class list already present) |
| `equipment/dodge_0.tres` | Change `unlock_tier = 0` → `unlock_tier = 1` |
| `equipment/dodge_1.tres` | Change `unlock_tier = 1` → `unlock_tier = 2`; add `unlock_class_ids = PackedStringArray(["ninja", "tempest", "hunter", "illusionist", "pyromancer", "hydromancer"])` |
| `equipment/movement_2.tres` | Add `unlock_class_ids = PackedStringArray(["cavalry", "dragoon", "alchemist"])` |
| `equipment/jump_2.tres` | Add `unlock_class_ids = PackedStringArray(["dragoon", "bastion", "bombardier"])` |

3. **Update `Town.gd`** — replace `TOWN_SHOPS` const and `_on_shop_pressed` function with the versions above.

4. **Build** the Godot project and confirm no import/script errors.

5. **Commit** with `feat: add equipment tier system with class-locked top-tier items and shop integration`.

---

## References

- [item_data.gd](EchoesOfChoiceTactical/scripts/data/item_data.gd) — `ItemData` resource class, `unlock_tier`, `unlock_class_ids` fields
- [game_state.gd](EchoesOfChoiceTactical/scripts/autoload/game_state.gd) — `is_item_unlocked()`, `equip_item()`, `get_all_equipped()`
- [Town.gd](EchoesOfChoiceTactical/scenes/town/Town.gd) — `TOWN_SHOPS`, `_on_shop_pressed`
- [Unit.gd](EchoesOfChoiceTactical/scenes/units/Unit.gd) — `_apply_equipment()` (how stat_bonuses are applied at battle start)
- Existing equipment examples: `resources/items/equipment/phys_atk_2.tres`, `resources/items/equipment/mag_def_2.tres`
- [class-reference](../class-reference/SKILL.md) — full 52-class listing with tier info
