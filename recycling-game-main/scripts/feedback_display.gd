extends Label

@export var level : Node


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey:
			visible = false
			get_tree().paused = false
			get_viewport().set_input_as_handled()
