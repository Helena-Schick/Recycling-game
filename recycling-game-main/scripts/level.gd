extends Node3D
@export var conveyor : Node
@export var arm : Node



func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_1"):
		_move_item(0)
	if Input.is_action_just_pressed("ui_2"):
		_move_item(1)
	if Input.is_action_just_pressed("ui_3"):
		_move_item(2)
	if Input.is_action_just_pressed("ui_4"):
		_move_item(3)
	
func _move_item(bin_number):
	var item = conveyor.grab_item()
	if item:
		if item.is_in_group("rubbish_items"):
			arm.target_item = item
			arm.target_bin = bin_number
