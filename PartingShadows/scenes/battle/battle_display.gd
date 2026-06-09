class_name BattleDisplay
extends RefCounted

## Display helper for the battle scene. Handles floating damage numbers,
## portrait cards, turn order display, and post-battle summary overlay.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityData := preload("res://scripts/data/ability_data.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const PortraitCard := preload("res://scripts/ui/portrait_card.gd")

var _battle: Control
var _shake_tween: Tween
var had_crit: bool = false


func _init(battle: Control) -> void:
	_battle = battle


func on_combat_event(target: FighterData, amount: int, event_type: String) -> void:
	# Track battle stats for party members (independent of card visuals)
	if event_type in ["damage", "crit", "spell_damage", "spell_crit"]:
		if _battle._current_actor != null and _battle._battle_stats.has(_battle._current_actor):
			_battle._battle_stats[_battle._current_actor]["damage_dealt"] += amount
		if _battle._battle_stats.has(target):
			_battle._battle_stats[target]["damage_taken"] += amount
	elif event_type == "heal":
		if _battle._current_actor != null and _battle._battle_stats.has(_battle._current_actor):
			_battle._battle_stats[_battle._current_actor]["healing_done"] += amount

	if event_type in ["crit", "spell_crit"]:
		had_crit = true

	var card: PortraitCard = find_card_for_fighter(target)
	if not card:
		return
	match event_type:
		"damage":
			SFXManager.play(SFXManager.Category.STRIKE, 1.0, true)
			card.flash_hit()
			card.show_floating_text("-%d" % amount, Color(1.0, 0.3, 0.3))
		"crit":
			SFXManager.play(SFXManager.Category.IMPACT, 1.0, true)
			card.flash_hit()
			card.show_floating_text("-%d!" % amount, Color(1.0, 0.85, 0.2), 22)
			screen_shake(4.0, 0.15)
		"spell_damage":
			SFXManager.play(SFXManager.Category.SPELL, 1.0, true)
			card.flash_hit()
			card.show_floating_text("-%d" % amount, Color(0.6, 0.4, 1.0))
		"spell_crit":
			SFXManager.play(SFXManager.Category.IMPACT, 1.0, true)
			card.flash_hit()
			card.show_floating_text("-%d!" % amount, Color(1.0, 0.85, 0.2), 22)
			screen_shake(4.0, 0.15)
		"heal":
			SFXManager.play(SFXManager.Category.SHIMMER, 1.0, true)
			card.show_floating_text("+%d" % amount, Color(0.3, 1.0, 0.4))
		"buff":
			SFXManager.play(SFXManager.Category.BUFF, 1.0, true)
			card.show_floating_text("BUFF", Color(0.4, 0.8, 1.0))
			_battle._tip_overlay.show_tip_once("status_effects",
				"Buffs and debuffs modify a fighter's stats for several " +
				"turns. Watch for status icons on the fighter portraits.\n\n" +
				"Select Stats during your turn to see exact effects on " +
				"each party member.")
		"debuff":
			SFXManager.play(SFXManager.Category.DEBUFF, 1.0, true)
			card.show_floating_text("DEBUFF", Color(0.8, 0.3, 0.8))
			_battle._tip_overlay.show_tip_once("status_effects",
				"Buffs and debuffs modify a fighter's stats for several " +
				"turns. Watch for status icons on the fighter portraits.\n\n" +
				"Select Stats during your turn to see exact effects on " +
				"each party member.")
		"miss":
			SFXManager.play(SFXManager.Category.WHOOSH, 0.7, true)
			card.show_floating_text("MISS", Color(0.7, 0.7, 0.7))
		"mp_restore":
			card.show_floating_text("+%d MP" % amount, Color(0.3, 0.6, 1.0))
			card.update_display(target)
		"block":
			SFXManager.play(SFXManager.Category.BUFF, 1.0, true)
			card.show_floating_text("BLOCK +%d MP" % amount, Color(0.4, 0.7, 1.0))
			card.update_display(target)
		"rest":
			SFXManager.play(SFXManager.Category.SHIMMER, 1.0, true)
			card.show_floating_text("REST +%d MP" % amount, Color(0.5, 0.8, 0.4))
			card.update_display(target)
		"charge_gain":
			card.show_floating_text("+%d" % amount, Color(0.85, 0.65, 0.15), 13)
			card.update_display(target)


func screen_shake(intensity: float, duration: float) -> void:
	if SettingsManager.reduced_motion:
		return
	if not _battle.is_inside_tree():
		return
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
	_battle.position = Vector2.ZERO
	_shake_tween = _battle.create_tween()
	var steps: int = maxi(3, int(duration / 0.03))
	for i: int in steps:
		var decay: float = 1.0 - float(i) / float(steps)
		var offset := Vector2(randf_range(-1, 1), randf_range(-1, 1)) * intensity * decay
		_shake_tween.tween_property(_battle, "position", offset, duration / float(steps))
	_shake_tween.tween_property(_battle, "position", Vector2.ZERO, 0.02)


func find_card_for_fighter(fighter: FighterData) -> PortraitCard:
	for card: PortraitCard in _battle._party_cards:
		if card.get_fighter() == fighter:
			return card
	for card: PortraitCard in _battle._enemy_cards:
		if card.get_fighter() == fighter:
			return card
	return null


func show_battle_summary() -> void:
	var overlay := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.08, 0.12, 0.92)
	style.border_color = Color(0.9, 0.8, 0.5, 0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(24)
	overlay.add_theme_stylebox_override("panel", style)
	overlay.set_anchors_preset(Control.PRESET_CENTER)
	overlay.offset_left = -220.0
	overlay.offset_top = -160.0
	overlay.offset_right = 220.0
	overlay.offset_bottom = 160.0
	overlay.pivot_offset = Vector2(220, 160)
	overlay.modulate.a = 0.0
	overlay.scale = Vector2(0.95, 0.95)
	_battle.add_child(overlay)

	# Fade-in + scale animation
	var intro_tw := _battle.create_tween().set_parallel(true)
	intro_tw.tween_property(overlay, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
	intro_tw.tween_property(overlay, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	overlay.add_child(vbox)

	var title := Label.new()
	title.text = "BATTLE SUMMARY"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(title)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	for f: FighterData in _battle._all_party:
		var stats: Dictionary = _battle._battle_stats.get(f, {})
		var dmg: int = stats.get("damage_dealt", 0)
		var heal: int = stats.get("healing_done", 0)
		var kills: int = stats.get("kills", 0)
		var line := Label.new()
		line.text = "%s the %s  -  DMG: %d, HEAL: %d, KOs: %d" % [
			f.character_name, f.character_type, dmg, heal, kills]
		line.add_theme_font_size_override("font_size", SettingsManager.font_size)
		vbox.add_child(line)

	var hint := Label.new()
	hint.text = "\nPress any key to continue..."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	vbox.add_child(hint)

	# Wait for confirm input or mouse click to dismiss
	await _battle.get_tree().create_timer(0.5, false).timeout  # Brief delay to prevent accidental skip
	_battle._summary_waiting = true
	while _battle._summary_waiting:
		await _battle.get_tree().process_frame
	overlay.queue_free()


func show_loot_drops(items: Array, gold: int) -> void:
	# Show tip before loot overlay so it renders on top
	var tip_shown: bool = not _battle._tip_overlay.was_seen("first_item_drop")
	_battle._tip_overlay.show_tip_once("first_item_drop",
		"After winning a battle, you may find loot dropped by " +
		"your enemies. Items are added to your shared inventory " +
		"(up to %d). Use items during battle from the Item menu." % GameState.inventory.MAX_ITEMS)
	if tip_shown:
		await _battle._tip_overlay.dismissed

	SFXManager.play(SFXManager.Category.SHIMMER, 1.0, true)

	var overlay := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.08, 0.12, 0.92)
	style.border_color = Color(0.9, 0.8, 0.5, 0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(24)
	overlay.add_theme_stylebox_override("panel", style)
	overlay.set_anchors_preset(Control.PRESET_CENTER)
	overlay.offset_left = -220.0
	overlay.offset_top = -140.0
	overlay.offset_right = 220.0
	overlay.offset_bottom = 140.0
	overlay.pivot_offset = Vector2(220, 140)
	overlay.modulate.a = 0.0
	overlay.scale = Vector2(0.95, 0.95)
	_battle.add_child(overlay)

	var intro_tw := _battle.create_tween().set_parallel(true)
	intro_tw.tween_property(overlay, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
	intro_tw.tween_property(overlay, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	overlay.add_child(vbox)

	var title := Label.new()
	title.text = "LOOT FOUND"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(title)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	if gold > 0:
		var gold_label := Label.new()
		gold_label.text = "+%d Gold" % gold
		gold_label.add_theme_font_size_override("font_size", SettingsManager.font_size)
		gold_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
		vbox.add_child(gold_label)

	var overflow_items: Array = []
	for item: ItemData in items:
		var line := Label.new()
		if not GameState.inventory.is_full():
			GameState.inventory.add_item(item)
			line.text = "+ %s  -  %s" % [item.item_name, item.get_use_description()]
			line.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
		else:
			overflow_items.append(item)
			line.text = "! %s  -  %s (inventory full)" % [item.item_name, item.get_use_description()]
			line.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
		line.add_theme_font_size_override("font_size", SettingsManager.font_size)
		vbox.add_child(line)

	var hint := Label.new()
	if overflow_items.is_empty():
		hint.text = "\nPress any key to continue..."
	else:
		hint.text = "\nPress any key to choose what to discard..."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	vbox.add_child(hint)

	await _battle.get_tree().create_timer(0.5, false).timeout
	_battle._loot_waiting = true
	while _battle._loot_waiting:
		await _battle.get_tree().process_frame
	overlay.queue_free()

	for overflow_item: ItemData in overflow_items:
		await _show_loot_discard(overflow_item)


func _show_loot_discard(new_item: ItemData) -> void:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.08, 0.12, 0.95)
	style.border_color = Color(0.9, 0.8, 0.5, 0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(20)
	panel.add_theme_stylebox_override("panel", style)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -260.0
	panel.offset_top = -180.0
	panel.offset_right = 260.0
	panel.offset_bottom = 180.0
	panel.modulate.a = 0.0
	_battle.add_child(panel)

	var tw := _battle.create_tween()
	tw.tween_property(panel, "modulate:a", 1.0, 0.2)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "Discard an item to pick up:"
	title.add_theme_font_size_override("font_size", SettingsManager.font_size - 6)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(title)

	var new_label := Label.new()
	new_label.text = "%s  -  %s" % [new_item.item_name, new_item.get_use_description()]
	new_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 6)
	new_label.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
	vbox.add_child(new_label)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	var result := [-1]
	var inv_items: Array = GameState.inventory.get_items()
	var buttons: Array[Button] = []
	for i: int in inv_items.size():
		var item: ItemData = inv_items[i]
		var btn := Button.new()
		btn.text = "%s  -  %s" % [item.item_name, item.get_use_description()]
		btn.add_theme_font_size_override("font_size", SettingsManager.font_size - 8)
		btn.focus_mode = Control.FOCUS_ALL
		var idx: int = i
		btn.pressed.connect(func() -> void: result[0] = idx)
		vbox.add_child(btn)
		buttons.append(btn)

	var skip_btn := Button.new()
	skip_btn.text = "Skip (discard loot)"
	skip_btn.add_theme_font_size_override("font_size", SettingsManager.font_size - 8)
	skip_btn.add_theme_color_override("font_color", Color(0.6, 0.5, 0.5))
	skip_btn.focus_mode = Control.FOCUS_ALL
	skip_btn.pressed.connect(func() -> void: result[0] = inv_items.size())
	vbox.add_child(skip_btn)
	buttons.append(skip_btn)

	for i: int in buttons.size():
		if i > 0:
			buttons[i].focus_neighbor_top = buttons[i - 1].get_path()
		if i < buttons.size() - 1:
			buttons[i].focus_neighbor_bottom = buttons[i + 1].get_path()
	buttons[0].grab_focus()

	while result[0] < 0:
		await _battle.get_tree().process_frame

	if result[0] < inv_items.size():
		GameState.inventory.remove_at(result[0])
		GameState.inventory.add_item(new_item)
		GameLog.info("Loot: discarded %s, picked up %s" % [inv_items[result[0]].item_name, new_item.item_name])
	else:
		GameLog.info("Loot: skipped %s" % new_item.item_name)

	panel.queue_free()


func show_victory_flash() -> void:
	if SettingsManager.reduced_motion:
		return
	# Flash surviving party cards gold
	for card: PortraitCard in _battle._party_cards:
		if card.get_fighter().health > 0 and card.is_inside_tree():
			var tw := card.create_tween()
			tw.tween_property(card, "modulate", Color(1.2, 1.1, 0.8), 0.15)
			tw.tween_property(card, "modulate", Color(1, 1, 1), 0.15)
	# Show centered VICTORY label
	_show_battle_end_label("VICTORY", Color(1.0, 0.85, 0.3), true)


func show_defeat_effect() -> void:
	if SettingsManager.reduced_motion:
		return
	# Desaturate the scene
	var tw := _battle.create_tween()
	tw.tween_property(_battle, "modulate", Color(0.3, 0.3, 0.3), 1.5)
	# Show centered DEFEAT label
	_show_battle_end_label("DEFEAT", Color(0.9, 0.25, 0.25), false)


func _show_battle_end_label(text: String, color: Color, bounce: bool) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER)
	var fs: int = SettingsManager.font_size + 16
	label.add_theme_font_size_override("font_size", fs)
	label.add_theme_font_override("font", preload("res://assets/fonts/Cinzel-Bold.ttf"))
	label.add_theme_color_override("font_color", color)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	label.pivot_offset = Vector2(100, 20)
	label.modulate.a = 0.0
	_battle.add_child(label)
	# Center the label properly once layout is ready
	label.offset_left = -100
	label.offset_right = 100
	label.offset_top = -20
	label.offset_bottom = 20

	var tw := _battle.create_tween().set_parallel(true)
	tw.tween_property(label, "modulate:a", 1.0, 0.3)
	if bounce:
		label.scale = Vector2(2.0, 2.0)
		tw.tween_property(label, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		label.scale = Vector2(1.0, 1.0)
	# Fade out after hold
	tw.chain().tween_property(label, "modulate:a", 0.0, 0.4).set_delay(1.0)
	tw.chain().tween_callback(label.queue_free)


func on_fighter_died(fighter: FighterData) -> void:
	# Track kills for party members
	if _battle._current_actor != null and _battle._battle_stats.has(_battle._current_actor) \
			and not _battle._all_party.has(fighter):
		_battle._battle_stats[_battle._current_actor]["kills"] += 1
	screen_shake(6.0, 0.25)


func rebuild_cards_if_needed() -> void:
	# Mark dead fighters' cards as dead (desaturated) instead of hiding
	for card: PortraitCard in _battle._party_cards:
		var fighter: FighterData = card.get_fighter()
		var is_dead: bool = not _battle._engine.units.has(fighter)
		card.set_dead(is_dead)
		card.update_display(fighter)
	for card: PortraitCard in _battle._enemy_cards:
		var fighter: FighterData = card.get_fighter()
		var is_dead: bool = not _battle._engine.enemies.has(fighter)
		card.set_dead(is_dead)
		card.update_display(fighter)


func compute_turn_order() -> void:
	## Predict the next several turns by simulating ATB ticks forward.
	_battle._turn_queue.clear()

	var all_fighters: Array = []
	for f: FighterData in _battle._engine.units:
		all_fighters.append(f)
	for f: FighterData in _battle._engine.enemies:
		all_fighters.append(f)

	if all_fighters.is_empty():
		return

	# Snapshot current ATB values
	var atb: Dictionary = {}
	for f: FighterData in all_fighters:
		atb[f] = f.turn_calculation

	var show_count: int = mini(8, all_fighters.size() * 2)

	while _battle._turn_queue.size() < show_count:
		# Tick until someone reaches 100
		var ready: Array = []
		for _i: int in 200:  # safety limit
			for f: FighterData in all_fighters:
				atb[f] += f.speed
			ready.clear()
			for f: FighterData in all_fighters:
				if atb[f] >= 100:
					ready.append(f)
			if not ready.is_empty():
				break

		if ready.is_empty():
			break

		# Sort by highest ATB (same as get_acting_units)
		ready.sort_custom(func(a: FighterData, b: FighterData) -> bool:
			return atb[a] > atb[b])

		for f: FighterData in ready:
			atb[f] -= 100
			_battle._turn_queue.append(f)


func display_turn_order() -> void:
	## Render the turn queue. Current actor in green, allies cyan, enemies salmon.
	var parts: Array[String] = []

	# Current actor first (green)
	if _battle._current_actor != null:
		parts.append("[color=lime]%s[/color]" % _battle._current_actor.character_name)

	# Remaining queue
	for f: FighterData in _battle._turn_queue:
		if _battle._engine.units.has(f):
			parts.append("[color=cyan]%s[/color]" % f.character_name)
		else:
			parts.append("[color=salmon]%s[/color]" % f.character_name)

	_battle._turn_order_label.clear()
	_battle._turn_order_label.append_text(
		"[color=gray]Turn Order:[/color]  " + "  >  ".join(parts))


func get_portrait_texture(fighter: FighterData) -> Texture2D:
	var key: String
	if fighter.is_user_controlled or fighter.is_shadow:
		key = fighter.character_type + "_" + fighter.portrait_variant
		if fighter.is_shadow:
			key += "_shadow"
	else:
		key = fighter.class_id if not fighter.class_id.is_empty() else fighter.character_type
	if _battle._portrait_cache.has(key):
		return _battle._portrait_cache[key]

	var path: String
	if fighter.is_user_controlled or fighter.is_shadow:
		var slug: String = fighter.character_type.to_lower().replace(" ", "_")
		path = "res://assets/art/portraits/classes/%s_%s.png" % [slug, fighter.portrait_variant]
	else:
		var slug: String = key.to_snake_case()
		path = "res://assets/art/portraits/enemies/%s.png" % slug

	var tex: Texture2D = null
	if ResourceLoader.exists(path):
		tex = load(path) as Texture2D

	_battle._portrait_cache[key] = tex
	return tex


func highlight_active_card(fighter: FighterData) -> void:
	# Deactivate previous
	if _battle._active_card:
		_battle._active_card.set_active(false)
		_battle._active_card = null

	if fighter == null:
		return

	# Find the card for this fighter
	for card: PortraitCard in _battle._party_cards:
		if card.get_fighter() == fighter:
			card.set_active(true)
			_battle._active_card = card
			return
	for card: PortraitCard in _battle._enemy_cards:
		if card.get_fighter() == fighter:
			card.set_active(true)
			_battle._active_card = card
			return
