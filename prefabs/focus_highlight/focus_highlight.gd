@tool
extends NinePatchRect
class_name FocusHighlight

const TEXTURE_OFFSET := Vector2(20, 20) # pixels

# TODO: when 4.3 releases, use @export_custom to link the component ratio by default
# see: https://github.com/godotengine/godot-proposals/discussions/9011
@export var offset := 10 * Vector2.ONE

@export var animate := true

var animation_offset := Vector2.ZERO:
	set(value):
		animation_offset = value
		if focused_element:
			global_position = focused_element.global_position - 0.5 * (TEXTURE_OFFSET + offset + animation_offset)
			size = focused_element.size + TEXTURE_OFFSET + offset + animation_offset

var focused_element

var tween : Tween


func _ready() -> void:
	# set up the highlight's texture
	texture = preload("images/highlight.png")
	for margin in ["top", "right", "bottom", "left"]:
		self["patch_margin_" + margin] = 31 # pixels

	if Engine.is_editor_hint():
		return

	hide() # until an UI element is focused

	# set up the animation
	tween = create_tween().set_loops()
	tween.tween_property(self, "animation_offset", 12 * Vector2.ONE, 0.4)
	tween.tween_property(self, "animation_offset", Vector2.ZERO, 0.4)
	tween.stop()

	# deferred, to allow containers updating the focused element's position first
	get_viewport().gui_focus_changed.connect(
		func(arg): self.on_gui_focus_changed.call_deferred(arg)
	)


func on_gui_focus_changed(node: Control) -> void:
	if node:
		focused_element = node
		if animate:
			tween.play()
		else:
			animation_offset = Vector2.ZERO
		show()
	else:
		if animate:
			tween.stop()
		hide()
