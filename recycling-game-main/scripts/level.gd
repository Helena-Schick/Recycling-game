extends Node3D

@export var arm : Node ## the mechanical arm node
@export var timer : Node ## the timer for how long to show feedback for
@export var conveyor : Node ## the conveyer belt node 
@export var camera_a : Node ## the main camera 
@export var camera_b : Node ## the second camera to switch to
@export var pause_menu : Node ## the pause menu canvas layer
@export var pause_button : Node ## the button that pauses the game
@export var score_display : Node ## the label that displays the player's score
@export var feedback_display : Node ## the label that displays feedback to the player
@export var arm_material : Resource ## the material resource for the arm
@export var settings_menu : PackedScene ## the scene for the settings menu
@export var main_menu_scene : PackedScene ## the main menu packed scene

var score : int = 0
var current_camera : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_data()
	arm_material.albedo_color = Global.colour


func _unhandled_input(_event: InputEvent) -> void:
	# handle inputs for controls
	if Input.is_action_just_pressed("ui_1"):
		_move_item(0)
	if Input.is_action_just_pressed("ui_2"):
		_move_item(1)
	if Input.is_action_just_pressed("ui_3"):
		_move_item(2)
	if Input.is_action_just_pressed("ui_4"):
		_move_item(3)
	
	# switch the active camera
	if Input.is_action_just_pressed("ui_spacebar"):
		if not get_tree().paused:
			current_camera = (current_camera + 1) % 2
			if current_camera == 0:
				camera_a.make_current()
			else:
				camera_b.make_current()


## makes the arm move an item to a specific bin
func _move_item(bin_number):
	var item = conveyor.grab_item()
	if item:
		if item.is_in_group("rubbish_items") and not arm.grabbed_item:
			arm.target_item = item
			arm.target_bin = bin_number


## pauses the game and opens the pause menu
func pause_game() -> void:
	pause_menu.visible = true
	get_tree().paused = true
	pause_button.visible = false
	if feedback_display.visible:
		feedback_display.visible = false


## unpauses the game and closes the pause menu
func _resume_game() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	pause_button.visible = true
	if feedback_display.visible:
		feedback_display.visible = false


## return to the main menu
func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


## increases or decreases the player's score by a given value
func change_score(value) -> void:
	score += value
	if score <= 0:
		score = 0
	score_display.text = "SCORE: " + str(score)


func _on_settings_pressed() -> void:
	var settings = settings_menu.instantiate()
	pause_menu.visible = false
	settings.main = self
	add_child(settings)


func show_feedback(text : String) -> void:
	feedback_display.visible = true
	feedback_display.text = text
	timer.start()


func _on_end_body_entered(body: Node3D) -> void:
	body.call_deferred("queue_free")
	change_score(-1)


func _on_timer_timeout() -> void:
	feedback_display.visible = false
