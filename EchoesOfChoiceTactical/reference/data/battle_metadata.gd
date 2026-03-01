class_name BattleMetadata extends RefCounted

## Static metadata for battle asset preloading.
## Maps battle_id -> { environment, enemy_paths } without calling factory methods.

const BATTLE_ASSETS: Dictionary = {
	"tutorial": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/guard_squire.tres",
			"res://resources/enemies/guard_mage.tres",
			"res://resources/enemies/guard_entertainer.tres",
			"res://resources/enemies/guard_scholar.tres",
		],
	},
	"city_street": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/thug.tres",
			"res://resources/enemies/street_tough.tres",
			"res://resources/enemies/hedge_mage.tres",
		],
	},
	"forest": {
		"environment": "forest",
		"enemy_paths": [
			"res://resources/enemies/forest_guardian.tres",
			"res://resources/enemies/grove_sprite.tres",
			"res://resources/enemies/gnoll_raider.tres",
			"res://resources/enemies/minotaur.tres",
		],
	},
	"village_raid": {
		"environment": "village",
		"enemy_paths": [
			"res://resources/enemies/goblin.tres",
			"res://resources/enemies/goblin_archer.tres",
			"res://resources/enemies/orc_shaman.tres",
			"res://resources/enemies/orc_warrior.tres",
		],
	},
	"smoke": {
		"environment": "scorched",
		"enemy_paths": [
			"res://resources/enemies/goblin_firestarter.tres",
			"res://resources/enemies/blood_fiend.tres",
			"res://resources/enemies/ogre.tres",
		],
	},
	"deep_forest": {
		"environment": "forest",
		"enemy_paths": [
			"res://resources/enemies/witch.tres",
			"res://resources/enemies/wisp.tres",
			"res://resources/enemies/sprite.tres",
			"res://resources/enemies/wild_huntsman.tres",
		],
	},
	"clearing": {
		"environment": "grassland",
		"enemy_paths": [
			"res://resources/enemies/satyr.tres",
			"res://resources/enemies/elf_ranger.tres",
			"res://resources/enemies/pixie.tres",
		],
	},
	"ruins": {
		"environment": "ruins",
		"enemy_paths": [
			"res://resources/enemies/shade.tres",
			"res://resources/enemies/wraith.tres",
			"res://resources/enemies/bone_sentry.tres",
		],
	},
	"cave": {
		"environment": "cave",
		"enemy_paths": [
			"res://resources/enemies/demon_archer.tres",
			"res://resources/enemies/frost_demon.tres",
			"res://resources/enemies/orc_scout.tres",
		],
	},
	"portal": {
		"environment": "portal",
		"enemy_paths": [
			"res://resources/enemies/hellion.tres",
			"res://resources/enemies/blood_imp.tres",
		],
	},
	"inn_ambush": {
		"environment": "inn",
		"enemy_paths": [
			"res://resources/enemies/skeleton_hunter.tres",
			"res://resources/enemies/dark_elf_assassin.tres",
			"res://resources/enemies/fallen_seraph.tres",
			"res://resources/enemies/shadow_demon.tres",
		],
	},
	"shore": {
		"environment": "shore",
		"enemy_paths": [
			"res://resources/enemies/medusa.tres",
			"res://resources/enemies/sea_elf.tres",
		],
	},
	"beach": {
		"environment": "shore",
		"enemy_paths": [
			"res://resources/enemies/captain.tres",
			"res://resources/enemies/pirate.tres",
			"res://resources/enemies/sea_shaman.tres",
		],
	},
	"cemetery_battle": {
		"environment": "cemetery",
		"enemy_paths": [
			"res://resources/enemies/zombie.tres",
			"res://resources/enemies/specter.tres",
			"res://resources/enemies/grave_wraith.tres",
		],
	},
	"box_battle": {
		"environment": "carnival",
		"enemy_paths": [
			"res://resources/enemies/ringmaster.tres",
			"res://resources/enemies/harlequin.tres",
			"res://resources/enemies/elf_enchantress.tres",
		],
	},
	"army_battle": {
		"environment": "camp",
		"enemy_paths": [
			"res://resources/enemies/commander.tres",
			"res://resources/enemies/shadow_fiend.tres",
			"res://resources/enemies/orc_warchanter.tres",
		],
	},
	"lab_battle": {
		"environment": "crypt",
		"enemy_paths": [
			"res://resources/enemies/frost_sentinel.tres",
			"res://resources/enemies/arc_golem.tres",
			"res://resources/enemies/skeleton_crusader.tres",
			"res://resources/enemies/ironclad.tres",
		],
	},
	"mirror_battle": {
		"environment": "mirror",
		"enemy_paths": [
			"res://resources/enemies/gorgon.tres",
			"res://resources/enemies/dark_elf_blade.tres",
			"res://resources/enemies/ghost_corsair.tres",
			"res://resources/enemies/dark_seraph.tres",
		],
	},
	"gate_ambush": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/ghost_corsair.tres",
			"res://resources/enemies/dark_elf_blade.tres",
			"res://resources/enemies/bone_sorcerer.tres",
			"res://resources/enemies/dark_seraph.tres",
		],
	},
	"city_gate_ambush": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/gorgon_queen.tres",
			"res://resources/enemies/dark_elf_warlord.tres",
			"res://resources/enemies/dire_shade.tres",
			"res://resources/enemies/phantom_prowler.tres",
			"res://resources/enemies/city_militia.tres",
		],
	},
	"return_city_1": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/seraph.tres",
			"res://resources/enemies/arch_hellion.tres",
			"res://resources/enemies/phantom_prowler.tres",
			"res://resources/enemies/dark_elf_warlord.tres",
		],
	},
	"return_city_2": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/necromancer.tres",
			"res://resources/enemies/elder_witch.tres",
			"res://resources/enemies/dire_shade.tres",
			"res://resources/enemies/dread_wraith.tres",
			"res://resources/enemies/phantom_prowler.tres",
		],
	},
	"return_city_3": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/psion.tres",
			"res://resources/enemies/runewright.tres",
			"res://resources/enemies/phantom_prowler.tres",
			"res://resources/enemies/dark_elf_warlord.tres",
		],
	},
	"return_city_4": {
		"environment": "city",
		"enemy_paths": [
			"res://resources/enemies/warlock.tres",
			"res://resources/enemies/shaman.tres",
			"res://resources/enemies/dire_shade.tres",
			"res://resources/enemies/phantom_prowler.tres",
			"res://resources/enemies/gorgon_queen.tres",
		],
	},
	"elemental_1": {
		"environment": "shrine",
		"enemy_paths": ["res://resources/enemies/fire_elemental.tres"],
	},
	"elemental_2": {
		"environment": "shrine",
		"enemy_paths": ["res://resources/enemies/water_elemental.tres"],
	},
	"elemental_3": {
		"environment": "shrine",
		"enemy_paths": ["res://resources/enemies/air_elemental.tres"],
	},
	"elemental_4": {
		"environment": "shrine",
		"enemy_paths": ["res://resources/enemies/earth_elemental.tres"],
	},
	"final_castle": {
		"environment": "castle",
		"enemy_paths": [
			"res://resources/enemies/the_stranger.tres",
			"res://resources/enemies/elite_guard_mage.tres",
			"res://resources/enemies/elite_guard_squire.tres",
		],
	},
	"travel_ambush": {
		"environment": "grassland",
		"enemy_paths": [
			"res://resources/enemies/thug.tres",
			"res://resources/enemies/street_tough.tres",
			"res://resources/enemies/goblin.tres",
			"res://resources/enemies/goblin_archer.tres",
			"res://resources/enemies/orc_warrior.tres",
			"res://resources/enemies/dark_elf_assassin.tres",
			"res://resources/enemies/skeleton_hunter.tres",
			"res://resources/enemies/shadow_demon.tres",
		],
	},
}


static func get_metadata(battle_id: String) -> Dictionary:
	return BATTLE_ASSETS.get(battle_id, {})
