## Generates SpriteFrames .tres resources from sprite sheet PNGs.
##
## Two modes:
##
## Mode 1 — Single sheet (original):
##   --script res://tools/create_spriteframes.gd -- <sprite_id> <png_path> [options]
##   One PNG with all animations stacked (rows = directions, columns = frames).
##
## Mode 2 — Directory (CraftPix multi-file):
##   --script res://tools/create_spriteframes.gd -- <sprite_id> --dir <folder_path> [options]
##   Folder with separate PNGs per animation (Idle, Walk/Run, Attack, Hurt, Death).
##   Each PNG has 4 direction rows (down/left/right/up) x N frame columns.
##
## Options (both modes):
##   --frame-width <int>    Frame width in pixels (default: 64)
##   --frame-height <int>   Frame height in pixels (default: 64)
##   --fps <int>            Animation FPS (default: 8)
##   --row-order <string>   Direction order per row (default: down,left,right,up)
##
## Single-sheet only:
##   --anims <string>       Animation names per row-group (default: idle,walk,attack,hurt,death)
##   --rows-per-anim <int>  Rows per animation (default: 4)
##   --single-dir           No directional rows (1 row = 1 animation)

extends SceneTree

const ANIM_KEYWORDS := {
	"idle": ["Idle"],
	"walk": ["Walk"],
	"attack": ["attack", "Attack"],
	"hurt": ["Hurt"],
	"death": ["Death"],
}
## Fallback: if no Walk file found, use Run as walk animation
const WALK_FALLBACK := ["Run"]
## Filename prefixes to skip (shadow overlay files, combo anims we don't need)
const SKIP_PREFIXES := ["shadow_", "Shadow_", "Shadow."]
const SKIP_CONTAINS := ["Run_Attack", "Walk_Attack"]
const LOOP_ANIMS := ["idle", "walk"]


func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		_print_usage()
		quit(1)
		return

	var sprite_id: String = args[0]

	# Parse optional arguments
	var frame_width := 64
	var frame_height := 64
	var fps := 8
	var row_order := ["down", "left", "right", "up"]
	var anim_names := ["idle", "walk", "attack", "hurt", "death"]
	var rows_per_anim := 4
	var single_dir := false
	var dir_path := ""

	var i := 1
	while i < args.size():
		match args[i]:
			"--dir":
				i += 1; dir_path = args[i]
			"--frame-width":
				i += 1; frame_width = int(args[i])
			"--frame-height":
				i += 1; frame_height = int(args[i])
			"--fps":
				i += 1; fps = int(args[i])
			"--row-order":
				i += 1; row_order = args[i].split(",")
			"--anims":
				i += 1; anim_names = args[i].split(",")
			"--rows-per-anim":
				i += 1; rows_per_anim = int(args[i])
			"--single-dir":
				single_dir = true
		i += 1

	if single_dir:
		rows_per_anim = 1

	if not dir_path.is_empty():
		_generate_from_dir(sprite_id, dir_path, frame_width, frame_height, fps, row_order)
	elif args.size() >= 2 and not args[1].begins_with("--"):
		_generate(sprite_id, args[1], frame_width, frame_height, fps, row_order, anim_names, rows_per_anim, single_dir)
	else:
		_print_usage()
		quit(1)
		return

	quit()


func _generate_from_dir(sprite_id: String, dir_path: String, fw: int, fh: int,
		fps: int, row_order: Array) -> void:
	## Scan directory for per-animation PNGs and build SpriteFrames.

	var dir := DirAccess.open(dir_path)
	if not dir:
		printerr("ERROR: Cannot open directory: %s" % dir_path)
		return

	# Collect PNG files
	var png_files: Array[String] = []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			png_files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if png_files.is_empty():
		printerr("ERROR: No PNG files found in: %s" % dir_path)
		return

	# Map files to animation names
	var anim_files: Dictionary = {}  # anim_name -> filename
	for fname in png_files:
		if _should_skip(fname):
			continue
		var anim := _classify_file(fname)
		if not anim.is_empty():
			anim_files[anim] = fname

	# If no Walk file, try Run as fallback
	if not anim_files.has("walk"):
		for fname in png_files:
			if _should_skip(fname):
				continue
			for keyword in WALK_FALLBACK:
				if fname.contains(keyword):
					anim_files["walk"] = fname
					break
			if anim_files.has("walk"):
				break

	if anim_files.is_empty():
		printerr("ERROR: No recognized animation files in: %s" % dir_path)
		return

	print("Directory mode: %s -> %d animations" % [sprite_id, anim_files.size()])

	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")

	# Process each animation file
	var anim_order := ["idle", "walk", "attack", "hurt", "death"]
	for anim_base in anim_order:
		if not anim_files.has(anim_base):
			continue

		var file_path := dir_path.path_join(anim_files[anim_base])
		if not ResourceLoader.exists(file_path):
			printerr("  SKIP: %s (file not found)" % file_path)
			continue

		var texture: Texture2D = load(file_path)
		if not texture:
			printerr("  SKIP: %s (load failed)" % file_path)
			continue

		var img_w := int(texture.get_width())
		var img_h := int(texture.get_height())
		var cols := img_w / fw
		var rows := img_h / fh

		if cols < 1 or rows < 1:
			printerr("  SKIP: %s (%dx%d too small for %dx%d frames)" % [anim_files[anim_base], img_w, img_h, fw, fh])
			continue

		var dir_count := mini(rows, row_order.size())
		for dir_i in range(dir_count):
			var direction: String = row_order[dir_i]
			var anim_name := "%s_%s" % [anim_base, direction]
			frames.add_animation(anim_name)
			frames.set_animation_speed(anim_name, fps)
			frames.set_animation_loop(anim_name, anim_base in LOOP_ANIMS)
			for col in range(cols):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(col * fw, dir_i * fh, fw, fh)
				frames.add_frame(anim_name, atlas)

		print("  %s: %s (%dx%d, %d frames x %d dirs)" % [anim_base, anim_files[anim_base], img_w, img_h, cols, dir_count])

	var output_path := "res://assets/art/sprites/spriteframes/%s.tres" % sprite_id
	var err := ResourceSaver.save(frames, output_path)
	if err == OK:
		print("Saved: %s (%d animations)" % [output_path, frames.get_animation_names().size()])
	else:
		printerr("ERROR: Failed to save %s (error %d)" % [output_path, err])


func _should_skip(filename: String) -> bool:
	for prefix in SKIP_PREFIXES:
		if filename.begins_with(prefix):
			return true
	for pattern in SKIP_CONTAINS:
		if filename.contains(pattern):
			return true
	return false


func _classify_file(filename: String) -> String:
	## Map a filename to an animation name based on keywords.
	for anim_name in ANIM_KEYWORDS:
		for keyword: String in ANIM_KEYWORDS[anim_name]:
			if filename.contains(keyword):
				return anim_name
	return ""


func _generate(sprite_id: String, png_path: String, fw: int, fh: int, fps: int,
		row_order: Array, anim_names: Array, rows_per_anim: int, single_dir: bool) -> void:
	## Original single-sheet mode.

	if not ResourceLoader.exists(png_path):
		printerr("ERROR: PNG not found: %s" % png_path)
		return

	var texture: Texture2D = load(png_path)
	if not texture:
		printerr("ERROR: Could not load texture: %s" % png_path)
		return

	var img_width := int(texture.get_width())
	var img_height := int(texture.get_height())
	var cols := img_width / fw
	var total_rows := img_height / fh

	print("Sprite sheet: %dx%d, frame: %dx%d, cols: %d, rows: %d" % [img_width, img_height, fw, fh, cols, total_rows])

	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")

	var row_idx := 0
	for anim_i in range(anim_names.size()):
		var anim_base: String = anim_names[anim_i]

		if single_dir:
			if row_idx >= total_rows:
				break
			frames.add_animation(anim_base)
			frames.set_animation_speed(anim_base, fps)
			frames.set_animation_loop(anim_base, anim_base in LOOP_ANIMS)
			for col in range(cols):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(col * fw, row_idx * fh, fw, fh)
				frames.add_frame(anim_base, atlas)
			row_idx += 1
		else:
			for dir_i in range(mini(rows_per_anim, row_order.size())):
				if row_idx >= total_rows:
					break
				var direction: String = row_order[dir_i]
				var anim_name := "%s_%s" % [anim_base, direction]
				frames.add_animation(anim_name)
				frames.set_animation_speed(anim_name, fps)
				frames.set_animation_loop(anim_name, anim_base in LOOP_ANIMS)
				for col in range(cols):
					var atlas := AtlasTexture.new()
					atlas.atlas = texture
					atlas.region = Rect2(col * fw, row_idx * fh, fw, fh)
					frames.add_frame(anim_name, atlas)
				row_idx += 1

	var output_path := "res://assets/art/sprites/spriteframes/%s.tres" % sprite_id
	var err := ResourceSaver.save(frames, output_path)
	if err == OK:
		print("Saved SpriteFrames: %s (%d animations)" % [output_path, frames.get_animation_names().size()])
	else:
		printerr("ERROR: Failed to save %s (error %d)" % [output_path, err])


func _print_usage() -> void:
	print("Usage:")
	print("  Single sheet: ... -- <sprite_id> <png_path> [options]")
	print("  Directory:    ... -- <sprite_id> --dir <folder_path> [options]")
	print("")
	print("Options:")
	print("  --frame-width <int>    Frame width in pixels (default: 64)")
	print("  --frame-height <int>   Frame height in pixels (default: 64)")
	print("  --fps <int>            Animation FPS (default: 8)")
	print("  --row-order <string>   Direction order per row (default: down,left,right,up)")
	print("  --anims <string>       Animation names per row-group (default: idle,walk,attack,hurt,death)")
	print("  --rows-per-anim <int>  Rows per animation (default: 4)")
	print("  --single-dir           No directional rows (1 row = 1 animation)")
