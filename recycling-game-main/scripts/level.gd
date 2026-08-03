extends Node3D

@export var arm : Node ## the mechanical arm node
@export var timer : Node ## the timer for how long to show feedback for
@export var conveyor : Node ## the conveyer belt node 
@export var camera_a : Node ## the main camera 
@export var camera_b : Node ## the second camera
@export var animation : Node ## the animation player for the score display
@export var pause_menu : Node ## the pause menu canvas layer
@export var pause_button : Node ## the button that pauses the game
@export var time_display : Node ## shows how long the user has been playing the level for
@export var score_display : Node ## the label that displays the player's score
@export var feedback_display : Node ## the label that displays feedback to the player
@export var arm_material : Resource ## the material resource for the arm
@export var settings_menu : PackedScene ## the scene for the settings menu
@export var main_menu_scene : PackedScene ## the main menu packed scene


enum bin_type {RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS}
const ITEM_VALUE : int = 10

var score : int = 0
var current_camera : int = 0
var time : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_data()
	arm_material.albedo_color = Global.settings["colour"]


func _unhandled_input(_event: InputEvent) -> void:
	# handle inputs for controls
	if Input.is_action_just_pressed("ui_1"):
		_move_item(bin_type.RUBBISH)
	if Input.is_action_just_pressed("ui_2"):
		_move_item(bin_type.COMPOST)
	if Input.is_action_just_pressed("ui_3"):
		_move_item(bin_type.RECYCLING)
	if Input.is_action_just_pressed("ui_4"):
		_move_item(bin_type.SOFT_PLASTICS)
	
	# switch the active camera when the space bar is pressed
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
	if score < 0:
		score = 0
	score_display.text = "SCORE: " + str(score)
	if value > 0:
		animation.play("correct")
	else:
		animation.play("incorrect")


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
	change_score(-ITEM_VALUE)


func _on_timer_timeout() -> void:
	feedback_display.visible = false


## increases the time display
func _on_level_timer_timeout() -> void:
	time += 1
	var minutes = str(int(time / 60.0))
	var seconds = str(time % 60)
	
	# format time
	if len(seconds) == 1:
		seconds = "0" + seconds
	if len(minutes) == 1:
		minutes = "0" + minutes
		
	time_display.text = minutes + ":" + seconds
	
	
