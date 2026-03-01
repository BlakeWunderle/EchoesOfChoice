extends Node

const SPRITEFRAMES_DIR := "res://assets/art/sprites/spriteframes/"
const PROCESSED_DIR := "res://assets/art/sprites/processed/"
const FRAME_SIZE := 64
const ANIM_NAMES: Array[String] = ["idle", "walk", "attack", "hurt", "death"]
const LOOP_ANIMS: Array[String] = ["idle", "walk"]
const DIR_ORDER_3: Array[String] = ["down", "right", "up"]
const DIR_ORDER_4: Array[String] = ["down", "left", "right", "up"]

var _cache: Dictionary = {}


func get_frames(sprite_id: String) -> SpriteFrames:
	if sprite_id.is_empty():
		return null
	if _cache.has(sprite_id):
		return _cache[sprite_id]

	# Try loading the pre-built .tres first
	var path := SPRITEFRAMES_DIR + sprite_id + ".tres"
	if ResourceLoader.exists(path):
		var frames = load(path)
		if frames is SpriteFrames:
			_cache[sprite_id] = frames
			return frames

	# Fallback: build SpriteFrames dynamically from processed PNGs
	var frames := _build_from_pngs(sprite_id)
	if frames:
		_cache[sprite_id] = frames
		return frames

	push_warning("SpriteLoader: No sprites found for '%s'" % sprite_id)
	return null


func _build_from_pngs(sprite_id: String) -> SpriteFrames:
	var dir_path := PROCESSED_DIR + sprite_id + "/"
	var global_dir := ProjectSettings.globalize_path(dir_path)

	# Check if the directory exists by trying to load idle.png
	var idle_global := global_dir + "idle.png"
	if not FileAccess.file_exists(idle_global):
		return null

	var sf := SpriteFrames.new()
	# Remove the default animation
	if sf.has_animation(&"default"):
		sf.remove_animation(&"default")

	var loaded_any := false

	for anim_name in ANIM_NAMES:
		var png_global := global_dir + anim_name + ".png"
		if not FileAccess.file_exists(png_global):
			continue

		var img := Image.load_from_file(png_global)
		if img == null or img.is_empty():
			continue

		var tex := ImageTexture.create_from_image(img)
		var cols := img.get_width() / FRAME_SIZE
		var rows := img.get_height() / FRAME_SIZE
		var dir_order: Array[String] = DIR_ORDER_3 if rows == 3 else DIR_ORDER_4
		var dir_count := mini(rows, dir_order.size())

		for dir_i in range(dir_count):
			var direction: String = dir_order[dir_i]
			var full_name := "%s_%s" % [anim_name, direction]
			sf.add_animation(StringName(full_name))
			sf.set_animation_speed(StringName(full_name), 8.0)
			sf.set_animation_loop(StringName(full_name), anim_name in LOOP_ANIMS)

			for col in range(cols):
				var atlas := AtlasTexture.new()
				atlas.atlas = tex
				atlas.region = Rect2(col * FRAME_SIZE, dir_i * FRAME_SIZE, FRAME_SIZE, FRAME_SIZE)
				sf.add_frame(StringName(full_name), atlas)

			loaded_any = true

	return sf if loaded_any else null


func clear_cache() -> void:
	_cache.clear()
