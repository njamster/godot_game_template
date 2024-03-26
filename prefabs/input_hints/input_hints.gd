@tool
extends PanelContainer
class_name InputHints


@export var hints : Array[String]:
	set(value):
		hints = value
		if is_inside_tree():
			_update_hints()

@export var outline_only := false:
	set(value):
		outline_only = value
		_update_hints()

@export var separation := 15:
	set(value):
		separation = value
		if is_inside_tree():
			$HBox.add_theme_constant_override("separation", separation)

@export var alignment := BoxContainer.ALIGNMENT_END:
	set(value):
		alignment = value
		if is_inside_tree():
			$HBox.alignment = alignment

@export var vertical_padding := 10:
	set(value):
		vertical_padding = value
		if is_inside_tree():
			var style_box := get_theme_stylebox("panel")
			style_box.content_margin_top = vertical_padding
			style_box.content_margin_bottom = vertical_padding

@export var padding_right := 25:
	set(value):
		padding_right = value
		if is_inside_tree():
			var style_box := get_theme_stylebox("panel")
			style_box.content_margin_right = padding_right

@export var padding_left := 25:
	set(value):
		padding_left = value
		if is_inside_tree():
			var style_box := get_theme_stylebox("panel")
			style_box.content_margin_left = padding_left

@export var bg_color := Color("#333"):
	set(value):
		bg_color = value
		if is_inside_tree():
			get_theme_stylebox("panel").bg_color = bg_color

@export var flat := false:
	set(value):
		flat = value
		if is_inside_tree():
			if flat:
				add_theme_stylebox_override("panel", StyleBoxEmpty.new())
				# re-trigger setters to set panel properties
				vertical_padding = vertical_padding
				padding_right = padding_right
				padding_left = padding_left
			else:
				add_theme_stylebox_override("panel", StyleBoxFlat.new())
				# re-trigger setters to set panel properties
				vertical_padding = vertical_padding
				padding_right = padding_right
				padding_left = padding_left
				bg_color = bg_color


func _ready() -> void:
	# add a container to hold all the hints
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", self.separation)
	hbox.alignment = self.alignment
	hbox.name = "HBox"
	add_child(hbox)

	# manually trigger the setters once
	outline_only = outline_only
	separation = separation
	alignment = alignment
	flat = flat

	hints = hints

	InputHandler.connect("mode_changed", _update_hints)


func _update_hints() -> void:
	if not has_node("HBox"):
		return

	var num_hints := hints.size()
	var num_nodes := $HBox.get_child_count()

	for hint_id in hints.size():
		var node

		if hint_id < num_nodes:
			# re-use existing node
			node = $HBox.get_child(hint_id)
		else:
			# create a new node
			node = Label.new()
			node.name = "Hint1"
			$HBox.add_child(node)

		var hint := hints[hint_id]
		var icon := InputHandler.get_icon(hint, outline_only)

		if icon:
			if node is Label:
				var new_node := TextureRect.new()
				node.replace_by(new_node)
				node.queue_free()
				node = new_node

			node.texture = icon
		else:
			if node is TextureRect:
				var new_node := Label.new()
				node.replace_by(new_node)
				node.queue_free()
				node = new_node

			node.text = hint

	# delete superfluous nodes
	for node_id in range(num_hints, num_nodes):
		$HBox.get_child(node_id).queue_free()
