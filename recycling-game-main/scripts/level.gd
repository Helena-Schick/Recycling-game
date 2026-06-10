extends Node3D

@export var conveyor : Node
@export var arm : Node
@export var pause_menu : Node
@export var main_menu_scene : PackedScene
@export var score_display : Node
@export var settings : PackedScene
@export var arm_colour : Resource

var score : int = 0


func _ready() -> void:
	Global.load_data()
	arm_colour.albedo_color = Global.colour
	


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


func open_pause_menu() -> void:
	pause_menu.visible = true
	get_tree().paused = true


func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


func change_score(value) -> void:
	score += value
	score_display.text = "SCORE: " + str(score)


func _on_settings_pressed() -> void:
	var settings_menu = settings.instantiate()
	pause_menu.visible = false
	settings_menu.main = self
	add_child(settings_menu)
	
	
