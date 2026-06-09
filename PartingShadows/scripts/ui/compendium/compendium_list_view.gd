class_name CompendiumListView extends VBoxContainer

## Paginated grid view displaying compendium cards.
## Uses CompendiumCard for each item and PaginationControls for navigation.

signal card_clicked(item_data: Dictionary, is_discovered: bool)

const CompendiumCard := preload("res://scripts/ui/compendium/compendium_card.gd")
const PaginationControls := preload("res://scripts/ui/compendium/pagination_controls.gd")

var items: Array = []  ## Array of {item data, is_discovered} dictionaries
var items_per_page: int = 12  ## Default: 3 rows × 4 columns

var _grid: GridContainer
var _scroll: ScrollContainer
var _pagination: PaginationControls
var _current_page: int = 1
var _cards: Array[CompendiumCard] = []  ## Current page's cards (avoids stale queue_free'd nodes)


func _ready() -> void:
	add_theme_constant_override("separation", 12)

	# Scroll container for grid
	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.custom_minimum_size = Vector2(970, 440)
	add_child(_scroll)

	# Grid container
	_grid = GridContainer.new()
	_grid.columns = 4
	_grid.add_theme_constant_override("h_separation", 10)
	_grid.add_theme_constant_override("v_separation", 10)
	_scroll.add_child(_grid)

	# Pagination controls
	_pagination = PaginationControls.new()
	_pagination.page_changed.connect(_on_page_changed)
	add_child(_pagination)

	_refresh_page()


## Set items and refresh display
func set_items(new_items: Array, per_page: int = 12, columns: int = 4) -> void:
	items = new_items
	items_per_page = per_page
	_current_page = 1
	if is_node_ready():
		_grid.columns = columns
		_pagination.current_page = 1
		_refresh_page()


## Get current page items
func _get_page_items() -> Array:
	var total_pages := ceili(float(items.size()) / float(items_per_page))
	_pagination.total_pages = total_pages

	var start_idx := (_current_page - 1) * items_per_page
	var end_idx := mini(start_idx + items_per_page, items.size())

	var page_items: Array = []
	for i in range(start_idx, end_idx):
		page_items.append(items[i])
	return page_items


## Refresh grid with current page items
func _refresh_page() -> void:
	if not is_node_ready():
		return

	# Reset scroll position
	_scroll.scroll_vertical = 0

	# Clear grid
	for child in _grid.get_children():
		child.queue_free()

	# Add cards for current page
	var page_items := _get_page_items()
	var cards: Array[CompendiumCard] = []
	for item_dict: Dictionary in page_items:
		var card := CompendiumCard.new()
		card.set_item(item_dict.get("data", {}), item_dict.get("is_discovered", false))
		card.clicked.connect(func(data: Dictionary) -> void:
			card_clicked.emit(data, item_dict.get("is_discovered", false))
		)
		_grid.add_child(card)
		cards.append(card)

	_cards = cards
	_wire_card_focus(cards)
	if not cards.is_empty() and is_visible_in_tree():
		cards[0].grab_focus()


## Set focus_neighbor_bottom on pagination buttons to an external node (e.g. back button).
func set_bottom_neighbor(node: Control) -> void:
	_pagination.set_bottom_neighbor(node)


## Set focus_neighbor_top on top-row cards to an external node (e.g. tab buttons).
func set_top_neighbor(node: Control) -> void:
	var cols: int = _grid.columns
	for i: int in mini(cols, _cards.size()):
		_cards[i].focus_neighbor_top = node.get_path()


## Return the pagination's focus target for external wiring.
func get_pagination_target() -> Button:
	return _pagination.get_focus_target()


## Return the NodePath to the first card, or empty if no cards exist.
func get_first_card_path() -> NodePath:
	if not _cards.is_empty():
		return _cards[0].get_path()
	return NodePath()


## Restore focus to the first card on the current page.
func grab_card_focus() -> void:
	if not _cards.is_empty():
		_cards[0].grab_focus()


func _on_page_changed(new_page: int) -> void:
	_current_page = new_page
	_refresh_page()


## Wire focus neighbors for grid navigation (left/right/up/down).
## Bottom row links down to pagination, pagination links up to top row.
func _wire_card_focus(cards: Array[CompendiumCard]) -> void:
	if cards.is_empty():
		return
	var cols: int = _grid.columns
	var pagination_target: Button = _pagination.get_focus_target()
	for i: int in cards.size():
		var card: CompendiumCard = cards[i]
		var col: int = i % cols

		# Left/right within row (stop at edges)
		if col > 0:
			card.focus_neighbor_left = cards[i - 1].get_path()
		else:
			card.focus_neighbor_left = cards[i].get_path()
		if col < cols - 1 and i + 1 < cards.size():
			card.focus_neighbor_right = cards[i + 1].get_path()
		else:
			card.focus_neighbor_right = cards[i].get_path()

		# Up/down between rows
		var up_idx: int = i - cols
		if up_idx >= 0:
			card.focus_neighbor_top = cards[up_idx].get_path()
		else:
			card.focus_neighbor_top = cards[i].get_path()
		var down_idx: int = i + cols
		if down_idx < cards.size():
			card.focus_neighbor_bottom = cards[down_idx].get_path()
		else:
			# Bottom row → pagination
			card.focus_neighbor_bottom = pagination_target.get_path()

	# Pagination → first card in top row
	_pagination.set_top_neighbor(cards[0])
