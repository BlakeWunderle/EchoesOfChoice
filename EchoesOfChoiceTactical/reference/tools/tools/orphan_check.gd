extends SceneTree
## Orphan resource & scene detector — run with:
##   Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/orphan_check.gd
## Optional: show all files (not just orphans):
##   ... -- --all
## Optional: filter by category name:
##   ... -- abilities
##   ... -- enemies --all
##
## Scans .tres resources and .tscn scenes for external references.
## Flags any file with zero references as an orphan.

# ─── Category definitions ────────────────────────────────────────────────────
const CATEGORIES: Array = [
	{"name": "Abilities", "dir": "res://resources/abilities", "ext": ".tres", "recursive": false},
	{"name": "Classes", "dir": "res://resources/classes", "ext": ".tres", "recursive": false},
	{"name": "Enemies", "dir": "res://resources/enemies", "ext": ".tres", "recursive": false},
	{"name": "Items — Consumable", "dir": "res://resources/items", "ext": ".tres", "recursive": false},
	{"name": "Items — Equipment", "dir": "res://resources/items/equipment", "ext": ".tres", "recursive": false},
	{"name": "Scenes", "dir": "res://scenes", "ext": ".tscn", "recursive": true},
]

# Directories to search for references (the "corpus")
const CORPUS_DIRS: Array = ["res://scripts", "res://scenes", "res://resources"]
const CORPUS_EXTS: Array = [".gd", ".tres", ".tscn"]
const EXTRA_CORPUS_FILES: Array = ["res://project.godot"]
# Tool scripts should not count as real references
const CORPUS_EXCLUDE: Array = ["res://tools"]

var _corpus: Dictionary = {}  # {res_path: String -> content: String}
var _show_all: bool = false
var _filter_category: String = ""


func _initialize() -> void:
	_parse_args()
	_build_corpus()

	print("")
	print("═══ Orphan Resource Check ═══")

	var total_checked: int = 0
	var total_orphans: int = 0
	var summary_lines: Array[String] = []

	for cat: Dictionary in CATEGORIES:
		if not _filter_category.is_empty() and not cat["name"].to_lower().contains(_filter_category):
			continue
		var files: Array[String] = _scan_dir(cat["dir"] as String, cat["ext"] as String, cat["recursive"] as bool)
		var orphan_count: int = _report_category(cat["name"] as String, files)
		total_checked += files.size()
		total_orphans += orphan_count
		var plural: String = "orphan" if orphan_count == 1 else "orphans"
		summary_lines.append("  %-24s %3d checked, %d %s" % [str(cat["name"]) + ":", files.size(), orphan_count, plural])

	print("")
	print("═══ Summary ═══")
	for line: String in summary_lines:
		print(line)
	var sep: String = ""
	for i: int in range(44):
		sep += "─"
	print("  " + sep)
	print("  %-24s %3d checked, %d orphans" % ["Total:", total_checked, total_orphans])
	print("")

	quit()


# ─── CLI argument parsing ────────────────────────────────────────────────────

func _parse_args() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for arg: String in args:
		if arg == "--all" or arg == "--verbose":
			_show_all = true
		elif not arg.begins_with("-"):
			_filter_category = arg.to_lower()


# ─── Corpus building ─────────────────────────────────────────────────────────

func _build_corpus() -> void:
	for dir_path: String in CORPUS_DIRS:
		_scan_corpus_dir(dir_path)
	for extra: String in EXTRA_CORPUS_FILES:
		var content: String = _load_text(extra)
		if not content.is_empty():
			_corpus[extra] = content


func _scan_corpus_dir(dir_path: String) -> void:
	for ex: String in CORPUS_EXCLUDE:
		if dir_path.begins_with(ex):
			return
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		var full: String = dir_path + "/" + fname
		if dir.current_is_dir():
			if not fname.begins_with("."):
				_scan_corpus_dir(full)
		else:
			for ext: String in CORPUS_EXTS:
				if fname.ends_with(ext):
					var content: String = _load_text(full)
					if not content.is_empty():
						_corpus[full] = content
					break
		fname = dir.get_next()
	dir.list_dir_end()


# ─── Directory scanning ──────────────────────────────────────────────────────

func _scan_dir(base_path: String, ext: String, recursive: bool) -> Array[String]:
	var results: Array[String] = []
	var dir: DirAccess = DirAccess.open(base_path)
	if dir == null:
		return results
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if dir.current_is_dir():
			if recursive and not fname.begins_with("."):
				results.append_array(_scan_dir(base_path + "/" + fname, ext, true))
		elif fname.ends_with(ext):
			results.append(base_path + "/" + fname)
		fname = dir.get_next()
	dir.list_dir_end()
	results.sort()
	return results


# ─── File reading ─────────────────────────────────────────────────────────────

func _load_text(res_path: String) -> String:
	var f: FileAccess = FileAccess.open(res_path, FileAccess.READ)
	if f == null:
		return ""
	var content: String = f.get_as_text()
	f.close()
	return content


# ─── Reference checking ──────────────────────────────────────────────────────

func _get_search_needles(target_path: String) -> Array[String]:
	var needles: Array[String] = []
	# Strategy A: full res:// path
	needles.append(target_path)
	# Strategy B: quoted basename (for dynamic loading via format strings)
	# Skip for .tscn files — scene refs always use full paths, and node names
	# in .tscn files share the stem causing false positives.
	if not target_path.ends_with(".tscn"):
		var stem: String = target_path.get_file().get_basename()
		needles.append("\"%s\"" % stem)
		# Strategy B+: equipment prefix form (Town.gd uses "equipment/health_0")
		if target_path.contains("/items/equipment/"):
			needles.append("\"equipment/%s\"" % stem)
	return needles


func _count_references(target_path: String) -> int:
	var needles: Array[String] = _get_search_needles(target_path)
	var ref_count: int = 0
	for corpus_path: String in _corpus:
		if corpus_path == target_path:
			continue
		var content: String = _corpus[corpus_path]
		var found: bool = false
		for needle: String in needles:
			if content.contains(needle):
				found = true
				break
		if found:
			ref_count += 1
	return ref_count


# ─── Reporting ────────────────────────────────────────────────────────────────

func _report_category(category: String, files: Array[String]) -> int:
	var pad_len: int = maxi(1, 60 - category.length() - 12)
	var pad: String = ""
	for i: int in range(pad_len):
		pad += "─"
	print("")
	print("── %s (%d files) %s" % [category, files.size(), pad])

	var orphans: Array[String] = []
	var ref_results: Array = []  # [[path, ref_count], ...]

	for fpath: String in files:
		var refs: int = _count_references(fpath)
		ref_results.append([fpath, refs])
		if refs == 0:
			orphans.append(fpath)

	if _show_all:
		for result: Array in ref_results:
			var fname: String = (result[0] as String).get_file()
			var refs: int = result[1] as int
			if refs == 0:
				print("  ⚠ ORPHAN  %-36s %d refs" % [fname, refs])
			else:
				print("  ✓         %-36s %d refs" % [fname, refs])
	else:
		for result: Array in ref_results:
			if (result[1] as int) == 0:
				print("  ⚠ ORPHAN  %s" % (result[0] as String).get_file())

	if orphans.is_empty():
		print("  ✓ %d checked, 0 orphans" % files.size())
	else:
		var plural: String = "" if orphans.size() == 1 else "s"
		print("  %d checked, %d orphan%s" % [files.size(), orphans.size(), plural])

	return orphans.size()
