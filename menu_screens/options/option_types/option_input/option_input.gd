@tool
extends PanelContainer

const INPUT_GRABBER := preload("res://menu_screens/options/input/input_grabber/input_grabber.tscn")


@onready var LABEL := %Label
@onready var KEYBOARD_BINDING := %KeyboardBinding
@onready var CONTROLLER_BINDING := %ControllerBinding


@export var input_action : String:
	set(value):
		input_action = value
		if is_inside_tree():
			LABEL.text = input_action.to_upper()
			KEYBOARD_BINDING.action_name = input_action
			CONTROLLER_BINDING.action_name = input_action


func _ready() -> void:
	input_action = input_action


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if InputHandler.mode == InputHandler.Modes.KEYBOARD:
			KEYBOARD_BINDING.emit_signal("pressed")
		elif InputHandler.mode == InputHandler.Modes.CONTROLLER:
			CONTROLLER_BINDING.emit_signal("pressed")


func _on_binding_pressed() -> void:
	var grabber := INPUT_GRABBER.instantiate()
	grabber.input_action = input_action
	grabber.input_mode = InputHandler.mode
	get_parent().get_parent().get_parent().add_child(grabber)
	grabber.grab_focus()
	get_viewport().set_input_as_handled()
	await grabber.tree_exited
	grab_focus()


func _on_keyboard_binding_pressed() -> void:
	var grabber := INPUT_GRABBER.instantiate()
	grabber.input_action = input_action
	grabber.input_mode = InputHandler.Modes.KEYBOARD
	get_parent().get_parent().get_parent().add_child(grabber)
	grabber.grab_focus()
	get_viewport().set_input_as_handled()
	await grabber.tree_exited
	grab_focus()


func _on_controller_binding_pressed() -> void:
	var grabber := INPUT_GRABBER.instantiate()
	grabber.input_action = input_action
	grabber.input_mode = InputHandler.Modes.CONTROLLER
	get_parent().get_parent().get_parent().add_child(grabber)
	grabber.grab_focus()
	get_viewport().set_input_as_handled()
	await grabber.tree_exited
	grab_focus()
