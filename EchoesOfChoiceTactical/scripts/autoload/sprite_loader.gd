extends Node

const SPRITEFRAMES_DIR := "res://assets/art/sprites/spriteframes/"

var _cache: Dictionary = {}


func get_frames(sprite_id: String) -> SpriteFrames:
	if sprite_id.is_empty():
		return null
	if _cache.has(sprite_id):
		return _cache[sprite_id]
	var path := SPRITEFRAMES_DIR + sprite_id + ".tres"
	if ResourceLoader.exists(path):
		var frames: SpriteFrames = load(path)
		_cache[sprite_id] = frames
		return frames
	push_warning("SpriteLoader: SpriteFrames not found for '%s' at %s" % [sprite_id, path])
	return null


func clear_cache() -> void:
	_cache.clear()
