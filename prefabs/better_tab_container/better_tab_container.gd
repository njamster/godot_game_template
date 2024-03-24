@tool
extends Container


#region ENUMS
enum TabBarPosition {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

enum AlignmentMode {
	BEGIN = BoxContainer.AlignmentMode.ALIGNMENT_BEGIN,
	CENTER = BoxContainer.AlignmentMode.ALIGNMENT_CENTER,
	END = BoxContainer.AlignmentMode.ALIGNMENT_END
}
#endregion

#region EXPORT VARS
@export_category("BetterTabContainer")
@export_group("Tab Bar", "tab_bar_")
@export var tab_bar_position := TabBarPosition.TOP:
	set(value):
		if tab_bar_position != value:
			tab_bar_position = value
			if is_inside_tree():
				_on_sort_children()

@export var tab_bar_alignment := AlignmentMode.BEGIN:
	set(value):
		tab_bar_alignment = value
		if is_inside_tree():
			match value:
				AlignmentMode.BEGIN:
					tab_bar.alignment = BoxContainer.ALIGNMENT_BEGIN
				AlignmentMode.CENTER:
					tab_bar.alignment = BoxContainer.ALIGNMENT_CENTER
				AlignmentMode.END:
					tab_bar.alignment = BoxContainer.ALIGNMENT_END

@export var tab_bar_minimum_size := 0:
	set(value):
		if value < 0:
			return
		tab_bar_minimum_size = value
		if is_inside_tree():
			tab_bar.custom_minimum_size.x = value

@export var tab_bar_separation := 0:
	set(value):
		if value < 0:
			return
		if tab_bar_separation != value:
			tab_bar_separation = value
			if is_inside_tree():
				_on_sort_children()

@export var tab_bar_opening_pad := 0:
	set(value):
		if value < 0:
			return
		tab_bar_opening_pad = value
		if is_inside_tree():
			_on_sort_children()

@export var tab_bar_closing_pad := 0:
	set(value):
		if value < 0:
			return
		tab_bar_closing_pad = value
		if is_inside_tree():
			_on_sort_children()

@export_group("Tabs", "tab_")
@export var tab_separation := 0:
	set(value):
		if value < 0:
			return
		tab_separation = value
		if is_inside_tree():
			tab_bar.add_theme_constant_override("separation", value)

@export var tab_text_alignment := AlignmentMode.CENTER:
	set(value):
		tab_text_alignment = value
		if is_inside_tree():
			for tab in tab_bar.get_children():
				match value:
					AlignmentMode.BEGIN:
						tab.alignment = BoxContainer.ALIGNMENT_BEGIN
					AlignmentMode.CENTER:
						tab.alignment = BoxContainer.ALIGNMENT_CENTER
					AlignmentMode.END:
						tab.alignment = BoxContainer.ALIGNMENT_END

@export var tab_shrink := false:
	set(value):
		tab_shrink = value
		if is_inside_tree():
			for tab in tab_bar.get_children():
				if tab_shrink:
					if tab_bar_position == TabBarPosition.LEFT:
						tab.size_flags_horizontal = SIZE_SHRINK_END
					if tab_bar_position == TabBarPosition.RIGHT:
						tab.size_flags_horizontal = SIZE_SHRINK_BEGIN
				else:
					tab.size_flags_horizontal = SIZE_FILL
#endregion

var _updating_visibility := false

@onready var tab_bar := BoxContainer.new()

var visible_tab := -1


func _ready() -> void:
	add_child(tab_bar, true, Node.INTERNAL_MODE_FRONT)
	tab_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tab_bar.top_level = true
	tab_bar.name = "TabBar"

	tab_bar_alignment = tab_bar_alignment
	tab_bar_minimum_size = tab_bar_minimum_size
	tab_bar_opening_pad = tab_bar_opening_pad
	tab_bar_closing_pad = tab_bar_closing_pad

	tab_separation = tab_separation
	tab_text_alignment = tab_text_alignment
	tab_shrink = tab_shrink


func _on_child_order_changed() -> void:
	if not tab_bar:
		await self.ready

	var num_nodes := get_child_count()
	var num_tabs := tab_bar.get_child_count()

	for i in range(num_nodes):
		var node := get_child(i)
		if i < num_tabs:
			# rename existing tab
			tab_bar.get_child(i).text = node.name
		else:
			# create additional tab
			node.connect("renamed", func():
				tab_bar.get_child(node.get_index()).text = node.name
				_on_sort_children()
			)
			node.connect("visibility_changed", func():
				if not _updating_visibility:
					_updating_visibility = true
					if node.visible:
						select_tab(node.get_index())
					_updating_visibility = false
			)
			_add_tab(node.name, i)
			if node.visible:
				select_tab(node.get_index())

	if num_tabs > num_nodes:
		# remove superfluous tabs
		for i in range(num_nodes, num_tabs):
			tab_bar.get_child(i).free()

	# if the previously visible tab was deleted, show the last one instead
	for i in get_child_count():
		if get_child(i).visible:
			return
	select_tab(get_child_count()-1)


func _add_tab(tab_name: String, tab_id: int) -> void:
	var is_restored := (tab_bar.get_child_count() < get_child_count())

	var tab = ResponsiveButton.new()
	tab.name = str(tab_id)
	tab_bar.add_child(tab)
	tab.text = tab_name
	tab.toggle_mode = true
	tab.focus_mode = FOCUS_NONE
	tab.connect("pressed", select_tab.bind(tab_id))

	if not is_restored:
		select_tab(tab_id)


func select_tab(tab_id: int) -> void:
	for i in tab_bar.get_child_count():
		get_child(i).visible = (i == tab_id)
		if (i == tab_id) and not Engine.is_editor_hint() and get_child(i).has_method("focus_first_option"):
			get_child(i).focus_first_option()
		tab_bar.get_child(i).focus_mode = FOCUS_NONE
		tab_bar.get_child(i).button_pressed = (i == tab_id)

	visible_tab = tab_id


func _on_sort_children() -> void:
	var available_space := Rect2(Vector2.ZERO, size)

	tab_bar.size = Vector2.ZERO # reset to minimum size
	tab_bar.global_position.x = self.global_position.x
	tab_bar.global_position.y = self.global_position.y

	match tab_bar_position:
		TabBarPosition.TOP:
			available_space = Rect2(
				0, tab_bar.size.y + tab_bar_separation,
				size.x, size.y - tab_bar.size.y - tab_bar_separation
			)
			tab_bar.global_position.x = self.global_position.x + tab_bar_opening_pad
			tab_bar.size.x = size.x - tab_bar_opening_pad - tab_bar_closing_pad
		TabBarPosition.RIGHT:
			available_space = Rect2(
				0, 0,
				size.x - tab_bar.size.x - tab_bar_separation, size.y
			)
			tab_bar.global_position.x = self.global_position.x + self.size.x - tab_bar.size.x
			tab_bar.global_position.y = self.global_position.y + tab_bar_opening_pad
			tab_bar.size.y = size.y - tab_bar_opening_pad - tab_bar_closing_pad
		TabBarPosition.BOTTOM:
			available_space = Rect2(
				0, 0,
				size.x, size.y - tab_bar.size.y - tab_bar_separation
			)
			tab_bar.global_position.x = self.global_position.x + tab_bar_opening_pad
			tab_bar.global_position.y = self.global_position.y + self.size.y - tab_bar.size.y
			tab_bar.size.x = size.x  - tab_bar_opening_pad - tab_bar_closing_pad
		TabBarPosition.LEFT:
			available_space = Rect2(
				tab_bar.size.x + tab_bar_separation, 0,
				size.x - tab_bar.size.x - tab_bar_separation, size.y
			)
			tab_bar.global_position.y = self.global_position.y + tab_bar_opening_pad
			tab_bar.size.y = size.y  - tab_bar_opening_pad - tab_bar_closing_pad

	tab_bar.vertical = (tab_bar_position == TabBarPosition.LEFT or tab_bar_position == TabBarPosition.RIGHT)

	for child_node in get_children():
		fit_child_in_rect(child_node, available_space)

		# modify vertical size flag (required for correct clipping)
		if child_node.size.y > available_space.size.y:
			if tab_bar_position == TabBarPosition.TOP:
				child_node.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
			elif tab_bar_position == TabBarPosition.BOTTOM:
				child_node.size_flags_vertical = Control.SIZE_SHRINK_END
			else:
				child_node.size_flags_vertical = Control.SIZE_FILL
		else:
			child_node.size_flags_vertical = Control.SIZE_FILL

		# modify horizontal size flag (required for correct clipping)
		if child_node.size.x > available_space.size.x:
			if tab_bar_position == TabBarPosition.LEFT:
				child_node.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			elif tab_bar_position == TabBarPosition.RIGHT:
				child_node.size_flags_horizontal = Control.SIZE_SHRINK_END
			else:
				child_node.size_flags_horizontal = Control.SIZE_FILL
		else:
			child_node.size_flags_horizontal = Control.SIZE_FILL


func focus_tab() -> void:
	for child in tab_bar.get_children():
		child.focus_mode = FOCUS_ALL
	var child_node := tab_bar.get_child(visible_tab)
	child_node.grab_focus()
	get_child(visible_tab).hide()
	visible_tab = -1
