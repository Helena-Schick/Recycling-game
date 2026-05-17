extends Node3D
@export var conveyor : Node
@export var arm : Node
@export var marker_1 : Node


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_1"):
		var item = conveyor.grab_item()
		if item:
			if item.is_in_group("rubbish_items"):
				arm.target_item = item
