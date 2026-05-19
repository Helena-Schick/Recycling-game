extends Node3D
@export var conveyor : Node
@export var arm : Node
@export var pause_menu : Node
@export var main_menu_scene : PackedScene
@export var score_display : Node

var score : int = 0


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


func _on_pause_pressed() -> void:
	pause_menu.visible = true
	get_tree().paused = true


func _on_resume_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


func change_score(value) -> void:
	score += value
	score_display.text = "SCORE: " + str(score)
