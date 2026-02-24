## Generates SpriteFrames .tres resources from CraftPix-style sprite sheet PNGs.
##
## CraftPix sprite sheets are organized as a grid of frames:
##   - Each row = one animation direction (typically: down, left, right, up)
##   - Each column = one frame in the animation sequence
##
## Usage:
##   --script res://tools/create_spriteframes.gd -- <sprite_id> <png_path> [options]
##
## Options:
##   --frame-width <int>    Frame width in pixels (default: 32)
##   --frame-height <int>   Frame height in pixels (default: 32)
##   --fps <int>            Animation FPS (default: 8)
##   --row-order <string>   Comma-separated direction order per row (default: down,left,right,up)
##   --anims <string>       Comma-separated animation names per row-group (default: idle,walk,attack,hurt,death)
##   --rows-per-anim <int>  How many rows per animation (default: 4, one per direction)
##   --single-dir           Animations have no directional rows (1 row = 1 anim)
##
## Examples:
##   # Standard 4-direction character (4 rows per anim: down/left/right/up)
##   ... -- swordsman_idle res://assets/art/sprites/characters/swordsman_idle.png
##
##   # Custom frame size and FPS
##   ... -- skeleton res://assets/art/sprites/enemies/skeleton.png --frame-width 48 --frame-height 48 --fps 10
##
##   # Single spritesheet with all animations (idle=rows 0-3, walk=rows 4-7, attack=rows 8-11)
##   ... -- knight res://assets/art/sprites/characters/knight_all.png --anims idle,walk,attack --rows-per-anim 4

extends SceneTree


func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		_print_usage()
		quit(1)
		return

	var sprite_id: String = args[0]
	var png_path: String = args[1]

	# Parse optional arguments
	var frame_width := 32
	var frame_height := 32
	var fps := 8
	var row_order := ["down", "left", "right", "up"]
	var anim_names := ["idle", "walk", "attack", "hurt", "death"]
	var rows_per_anim := 4
	var single_dir := false

	var i := 2
	while i < args.size():
		match args[i]:
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

	_generate(sprite_id, png_path, frame_width, frame_height, fps, row_order, anim_names, rows_per_anim, single_dir)
	quit()


func _generate(sprite_id: String, png_path: String, fw: int, fh: int, fps: int,
		row_order: Array, anim_names: Array, rows_per_anim: int, single_dir: bool) -> void:

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
	# Remove default animation
	if frames.has_animation("default"):
		frames.remove_animation("default")

	var row_idx := 0
	for anim_i in range(anim_names.size()):
		var anim_base: String = anim_names[anim_i]

		if single_dir:
			# Single row = one animation, no directional suffix
			if row_idx >= total_rows:
				break
			frames.add_animation(anim_base)
			frames.set_animation_speed(anim_base, fps)
			frames.set_animation_loop(anim_base, anim_base in ["idle", "walk"])
			for col in range(cols):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(col * fw, row_idx * fh, fw, fh)
				frames.add_frame(anim_base, atlas)
			row_idx += 1
		else:
			# Multiple rows per animation (one per direction)
			for dir_i in range(mini(rows_per_anim, row_order.size())):
				if row_idx >= total_rows:
					break
				var direction: String = row_order[dir_i]
				var anim_name := "%s_%s" % [anim_base, direction]
				frames.add_animation(anim_name)
				frames.set_animation_speed(anim_name, fps)
				frames.set_animation_loop(anim_name, anim_base in ["idle", "walk"])
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
	print("Usage: --script res://tools/create_spriteframes.gd -- <sprite_id> <png_path> [options]")
	print("")
	print("Options:")
	print("  --frame-width <int>    Frame width in pixels (default: 32)")
	print("  --frame-height <int>   Frame height in pixels (default: 32)")
	print("  --fps <int>            Animation FPS (default: 8)")
	print("  --row-order <string>   Direction order per row (default: down,left,right,up)")
	print("  --anims <string>       Animation names per row-group (default: idle,walk,attack,hurt,death)")
	print("  --rows-per-anim <int>  Rows per animation (default: 4)")
	print("  --single-dir           No directional rows (1 row = 1 animation)")
