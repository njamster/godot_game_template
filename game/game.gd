extends Node


func _process(delta: float) -> void:
	%PathFollow2D.progress += 300 * delta
