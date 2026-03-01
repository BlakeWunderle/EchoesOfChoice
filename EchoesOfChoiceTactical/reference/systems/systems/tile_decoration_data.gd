class_name TileDecorationData extends RefCounted

## Maps environments to decoration sprite paths for walls and destructibles.

# Wall object sprites per environment (drawn on wall tiles)
const WALL_OBJECTS: Dictionary = {
	"grassland": [
		"res://assets/art/tilesets/battle/grassland/PNG/Objects_separated/Stone1_grass_shadow.png",
		"res://assets/art/tilesets/battle/grassland/PNG/Objects_separated/Stone2_grass_shadow.png",
	],
	"forest": [
		"res://assets/art/tilesets/battle/forest/PNG/Objects_separated/Stone_with_grass1.png",
		"res://assets/art/tilesets/battle/forest/PNG/Objects_separated/Stone_with_grass2.png",
	],
	"cave": [
		"res://assets/art/tilesets/battle/cave/PNG/Objects_separately/Stone1.png",
		"res://assets/art/tilesets/battle/cave/PNG/Objects_separately/Stone2.png",
	],
	"ruins": [
		"res://assets/art/tilesets/battle/rocky/PNG/Objects_separately/Stone_grass_1.png",
		"res://assets/art/tilesets/battle/rocky/PNG/Objects_separately/Stone_grass_2.png",
	],
	"cemetery": [
		"res://assets/art/tilesets/battle/undead/PNG/Objects_separately/Stone1.png",
		"res://assets/art/tilesets/battle/undead/PNG/Objects_separately/Stone2.png",
	],
	"scorched": [
		"res://assets/art/tilesets/battle/cursed_land/PNG/Objects_separetely/Stone1.png",
		"res://assets/art/tilesets/battle/cursed_land/PNG/Objects_separetely/Stone2.png",
	],
	"shore": [
		"res://assets/art/tilesets/battle/desert/PNG/Objects_separately/Stone1.png",
		"res://assets/art/tilesets/battle/desert/PNG/Objects_separately/Stone2.png",
	],
	"shrine": [
		"res://assets/art/tilesets/battle/glowing_cave/PNG/Objects_separately/Stone1.png",
		"res://assets/art/tilesets/battle/glowing_cave/PNG/Objects_separately/Stone2.png",
	],
}

# Destructible object sprites (crates, barrels) — reuse across environments
const DESTRUCTIBLE_OBJECTS: Array[String] = [
	"res://assets/art/tilesets/battle/grassland/PNG/Objects_separated/Rock_grass_element11.png",
	"res://assets/art/tilesets/battle/grassland/PNG/Objects_separated/Rock_grass_element12.png",
]

# Detail scatter sprites per environment (small ground decorations)
const DETAIL_SPRITES: Dictionary = {
	"grassland": "res://assets/art/tilesets/battle/grassland/PNG/Details.png",
	"forest": "res://assets/art/tilesets/battle/forest/PNG/Details.png",
	"cave": "res://assets/art/tilesets/battle/cave/PNG/Details.png",
	"ruins": "res://assets/art/tilesets/battle/rocky/PNG/Details.png",
	"cemetery": "res://assets/art/tilesets/battle/undead/PNG/Details.png",
	"scorched": "res://assets/art/tilesets/battle/cursed_land/PNG/Details.png",
	"shore": "res://assets/art/tilesets/battle/desert/PNG/Details.png",
	"shrine": "res://assets/art/tilesets/battle/glowing_cave/PNG/Details.png",
	"swamp": "res://assets/art/tilesets/battle/swamp/PNG/Details.png",
}

# Environments that inherit from another's objects
const ENVIRONMENT_FALLBACKS: Dictionary = {
	"village": "grassland",
	"camp": "grassland",
	"carnival": "grassland",
	"deep_forest": "forest",
	"portal": "scorched",
	"mirror": "shrine",
	"city": "ruins",
	"castle": "ruins",
	"crypt": "cave",
	"inn": "grassland",
}

var _tex_cache: Dictionary = {}


func get_wall_sprite(environment: String, variant: int) -> Texture2D:
	var env := _resolve_env(environment)
	var paths: Array = WALL_OBJECTS.get(env, [])
	if paths.is_empty():
		return null
	var path: String = paths[variant % paths.size()]
	return _load_tex(path)


func get_destructible_sprite(variant: int) -> Texture2D:
	if DESTRUCTIBLE_OBJECTS.is_empty():
		return null
	var path: String = DESTRUCTIBLE_OBJECTS[variant % DESTRUCTIBLE_OBJECTS.size()]
	return _load_tex(path)


func get_detail_sheet(environment: String) -> Texture2D:
	var env := _resolve_env(environment)
	var path: String = DETAIL_SPRITES.get(env, "")
	if path.is_empty():
		return null
	return _load_tex(path)


func _resolve_env(environment: String) -> String:
	if WALL_OBJECTS.has(environment):
		return environment
	return ENVIRONMENT_FALLBACKS.get(environment, "grassland")


func _load_tex(path: String) -> Texture2D:
	if path in _tex_cache:
		return _tex_cache[path]
	if not ResourceLoader.exists(path):
		_tex_cache[path] = null
		return null
	var tex := load(path) as Texture2D
	_tex_cache[path] = tex
	return tex
