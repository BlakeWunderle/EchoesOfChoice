class_name TileTextureCache extends RefCounted

## Caches ground tile textures from CraftPix tilesets for each environment.
## Each environment maps to a tileset pack and specific 16x16 tile regions.

const TILE_PX := 16

# Environment -> tileset file path and ground tile regions (Rect2i in 16px coords).
# Each entry has "path" and "regions" (array of Rect2i pixel rects for fill tiles).
const ENVIRONMENT_TILES: Dictionary = {
	"grassland": {
		"path": "res://assets/art/tilesets/battle/grassland/PNG/ground_grasss.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"forest": {
		"path": "res://assets/art/tilesets/battle/forest/PNG/Ground_grass.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"cave": {
		"path": "res://assets/art/tilesets/battle/cave/PNG/ground_source.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"city": {
		"path": "res://assets/art/tilesets/battle/guild_hall/PNG/Walls_street.png",
		"regions": [Rect2i(64, 192, 16, 16), Rect2i(80, 192, 16, 16), Rect2i(64, 208, 16, 16), Rect2i(80, 208, 16, 16)],
	},
	"ruins": {
		"path": "res://assets/art/tilesets/battle/rocky/PNG/Ground_moss.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"cemetery": {
		"path": "res://assets/art/tilesets/battle/undead/PNG/Ground_rocks.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"shore": {
		"path": "res://assets/art/tilesets/battle/desert/PNG/Ground_grass.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"inn": {
		"path": "res://assets/art/tilesets/battle/dungeon_free/PNG/walls_floor.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"scorched": {
		"path": "res://assets/art/tilesets/battle/cursed_land/PNG/Ground.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"crypt": {
		"path": "res://assets/art/tilesets/battle/dungeon_premium/PNG/walls_floor.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"castle": {
		"path": "res://assets/art/tilesets/battle/dungeon_premium/PNG/walls_floor.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"shrine": {
		"path": "res://assets/art/tilesets/battle/glowing_cave/PNG/Ground.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"portal": {
		"path": "res://assets/art/tilesets/battle/cursed_land/PNG/Ground.png",
		"regions": [Rect2i(144, 32, 16, 16), Rect2i(160, 32, 16, 16), Rect2i(144, 48, 16, 16), Rect2i(160, 48, 16, 16)],
	},
	"village": {
		"path": "res://assets/art/tilesets/battle/grassland/PNG/ground_grasss.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"camp": {
		"path": "res://assets/art/tilesets/battle/grassland/PNG/ground_grasss.png",
		"regions": [Rect2i(144, 32, 16, 16), Rect2i(160, 32, 16, 16), Rect2i(144, 48, 16, 16), Rect2i(160, 48, 16, 16)],
	},
	"carnival": {
		"path": "res://assets/art/tilesets/battle/grassland/PNG/ground_grasss.png",
		"regions": [Rect2i(64, 32, 16, 16), Rect2i(80, 32, 16, 16), Rect2i(64, 48, 16, 16), Rect2i(80, 48, 16, 16)],
	},
	"mirror": {
		"path": "res://assets/art/tilesets/battle/glowing_cave/PNG/Ground.png",
		"regions": [Rect2i(144, 32, 16, 16), Rect2i(160, 32, 16, 16), Rect2i(144, 48, 16, 16), Rect2i(160, 48, 16, 16)],
	},
	"deep_forest": {
		"path": "res://assets/art/tilesets/battle/forest/PNG/Ground_grass.png",
		"regions": [Rect2i(144, 32, 16, 16), Rect2i(160, 32, 16, 16), Rect2i(144, 48, 16, 16), Rect2i(160, 48, 16, 16)],
	},
}

# Wall texture regions per environment
const WALL_TILES: Dictionary = {
	"grassland": {"path": "res://assets/art/tilesets/battle/grassland/PNG/ground_grasss.png", "region": Rect2i(0, 192, 16, 16)},
	"forest": {"path": "res://assets/art/tilesets/battle/forest/PNG/Ground_grass.png", "region": Rect2i(0, 192, 16, 16)},
	"cave": {"path": "res://assets/art/tilesets/battle/cave/PNG/ground_source.png", "region": Rect2i(0, 64, 16, 16)},
	"city": {"path": "res://assets/art/tilesets/battle/guild_hall/PNG/Walls_street.png", "region": Rect2i(0, 192, 16, 16)},
	"castle": {"path": "res://assets/art/tilesets/battle/dungeon_premium/PNG/walls_floor.png", "region": Rect2i(0, 192, 16, 16)},
	"inn": {"path": "res://assets/art/tilesets/battle/dungeon_free/PNG/walls_floor.png", "region": Rect2i(0, 64, 16, 16)},
	"crypt": {"path": "res://assets/art/tilesets/battle/dungeon_premium/PNG/walls_floor.png", "region": Rect2i(0, 64, 16, 16)},
}

var _cache: Dictionary = {}  # "env_ground_0" -> AtlasTexture
var _sheet_cache: Dictionary = {}  # path -> Texture2D


func get_ground_texture(environment: String, variant: int) -> Texture2D:
	var key := "%s_ground_%d" % [environment, variant]
	if key in _cache:
		return _cache[key]

	var env_data: Dictionary = ENVIRONMENT_TILES.get(environment, {})
	if env_data.is_empty():
		return null

	var sheet := _load_sheet(env_data["path"])
	if sheet == null:
		return null

	var regions: Array = env_data["regions"]
	var region: Rect2i = regions[variant % regions.size()]

	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(region)
	_cache[key] = atlas
	return atlas


func get_ground_variant_count(environment: String) -> int:
	var env_data: Dictionary = ENVIRONMENT_TILES.get(environment, {})
	if env_data.is_empty():
		return 0
	return env_data["regions"].size()


func get_wall_texture(environment: String) -> Texture2D:
	var key := "%s_wall" % environment
	if key in _cache:
		return _cache[key]

	var wall_data: Dictionary = WALL_TILES.get(environment, {})
	if wall_data.is_empty():
		return null

	var sheet := _load_sheet(wall_data["path"])
	if sheet == null:
		return null

	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(wall_data["region"])
	_cache[key] = atlas
	return atlas


func _load_sheet(path: String) -> Texture2D:
	if path in _sheet_cache:
		return _sheet_cache[path]
	if not ResourceLoader.exists(path):
		return null
	var tex := load(path) as Texture2D
	_sheet_cache[path] = tex
	return tex
