@tool
class_name ResponsiveButton
extends Button

enum Mode {
	DYNAMIC = -1,
	KEYBOARD = InputHandler.Modes.KEYBOARD,
	CONTROLLER = InputHandler.Modes.CONTROLLER
}

@export_group("Sounds")
@export var focus_sound : AudioStream
@export var press_sound : AudioStream

var focus_sound_disabled := false


@export_group("Input Prompt")
@export var action_name : String:
	set(value):
		action_name = value
		_update_input_icon()

@export var mode := Mode.DYNAMIC:
	set(value):
		mode = value
		_update_input_icon()

@export var outline_only := false:
	set(value):
		outline_only = value
		_update_input_icon()


func _ready() -> void:
	self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	connect("mouse_entered", _play_focus_sound)
	connect("gui_input", _on_gui_input)

	connect("pressed", _play_press_sound)

	InputHandler.connect("mode_changed", _update_input_icon)


func _update_input_icon() -> void:
	if self.action_name == "":
		return

	icon = InputHandler.get_icon(self.action_name, self.outline_only, self.mode)


func grab_focus_silently() -> void:
	focus_sound_disabled = true
	grab_focus()
	focus_sound_disabled = false


func _on_gui_input(event: InputEvent) -> void:
	var focus_neighbor : Control

	if event.is_action_pressed("ui_up", true, true):
		focus_neighbor = find_valid_focus_neighbor(SIDE_TOP)
	elif event.is_action_pressed("ui_right", true, true):
		focus_neighbor = find_valid_focus_neighbor(SIDE_RIGHT)
	elif event.is_action_pressed("ui_down", true, true):
		focus_neighbor = find_valid_focus_neighbor(SIDE_BOTTOM)
	elif event.is_action_pressed("ui_left", true, true):
		focus_neighbor = find_valid_focus_neighbor(SIDE_LEFT)
	elif event.is_action_pressed("ui_focus_next", true, true):
		focus_neighbor = find_next_valid_focus()
	elif event.is_action_pressed("ui_focus_prev", true, true):
		focus_neighbor = find_prev_valid_focus()

	if focus_neighbor and focus_neighbor is ResponsiveButton:
		focus_neighbor._play_focus_sound()


func _play_focus_sound() -> void:
	if focus_sound_disabled or disabled:
		return

	if focus_sound:
		SoundManager.play_ui_sound(focus_sound.resource_path)
	else:
		SoundManager.play_ui_sound("res://prefabs/responsive_button/sounds/focus.ogg")


func _play_press_sound() -> void:
	if press_sound:
		SoundManager.play_ui_sound(press_sound.resource_path)
	else:
		SoundManager.play_ui_sound("res://prefabs/responsive_button/sounds/press.ogg")
