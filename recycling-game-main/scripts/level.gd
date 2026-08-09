extends Node3D

@export var arm: Node ## The mechanical arm node
@export var timer: Node ## The timer for how long to show feedback for
@export var spawner: Node ## The item spawner
@export var conveyor: Node ## The main conveyer belt node 
@export var camera_a: Node ## The main camera 
@export var camera_b: Node ## The second camera
@export var animation: Node ## The animation player for the score display
@export var pause_menu: Node ## The pause menu canvas layer
@export var path_follow: Node ## The path follow node for spawning on the conveyer
@export var pause_button: Node ## The button that pauses the game
@export var time_display: Node ## Shows how long the user has been playing the level for
@export var score_display: Node ## The label that displays the player's score
@export var feedback_display: Node ## The label that displays feedback to the player
@export var arm_material: Resource ## The material resource for the arm
@export var item_scene: PackedScene ## The item scene
@export var settings_menu: PackedScene ## The scene for the settings menu
@export var game_over_menu: PackedScene ## The menu that shows when the game ends
@export var main_menu_scene: PackedScene ## The main menu packed scene
@export var lives_display: Node ## The label that shows lives left


enum bin_type { RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS }
const ITEM_VALUE: int = 10
const SCORE_TEXT: String = "SCORE: "
const CAMERAS: int = 3 ## The number of cameras
const START_ITEMS: int = 6 ## The number of items that start on the conveyer

var score: int = 0 ## The current score
var lives: int = 3 ## The number of incorrect guesses left
var current_camera: int = 0 ## The active camera number
var time: int = 0 ## How long the game has been running
var camera_c: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_data()
	arm_material.albedo_color = Global.settings["colour"]
	camera_c = arm.camera_c
	camera_a.make_current()
	
	# Create items along conveyer
	for item_number in range(START_ITEMS):
		path_follow.progress_ratio = (item_number - randf() * spawner.randomness) / float(START_ITEMS)
		spawner.spawn_item(path_follow.global_position)


func _unhandled_input(event: InputEvent) -> void:
	# Handle inputs for controls
	if event.is_action_pressed("ui_1"):
		_move_item(bin_type.RUBBISH)
	elif event.is_action_pressed("ui_2"):
		_move_item(bin_type.COMPOST)
	elif event.is_action_pressed("ui_3"):
		_move_item(bin_type.RECYCLING)
	elif event.is_action_pressed("ui_4"):
		_move_item(bin_type.SOFT_PLASTICS)
	
	# Switch the active camera when the space bar is pressed
	elif event.is_action_pressed("ui_spacebar"):
		if not get_tree().paused:
			current_camera = (current_camera + 1) % CAMERAS
			if current_camera == 0:
				camera_a.make_current()
			elif current_camera == 1:
				camera_b.make_current()
			else:
				camera_c.make_current()


## Makes the arm move an item to a specific bin
func _move_item(bin: bin_type):
	var item = conveyor.grab_item()
	if item:
		if item.is_in_group("rubbish_items") and not arm.grabbed_item:
			arm.target_item = item
			arm.target_bin = bin


## Pauses the game and opens the pause menu
func pause_game() -> void:
	pause_menu.visible = true
	get_tree().paused = true
	pause_button.visible = false
	if feedback_display.visible:
		feedback_display.visible = false


## Unpauses the game and closes the pause menu
func _resume_game() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	pause_button.visible = true
	if feedback_display.visible:
		feedback_display.visible = false


## Return to the main menu
func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


## Increases or decreases the player's score by a given value
func change_score(value: int) -> void:
	score += value
	if score < 0:
		score = 0
	score_display.text = SCORE_TEXT + str(score)
	
	# Play score label animations
	if value > 0:
		animation.play("correct")
	else:
		animation.play("incorrect")


func decrease_lives() -> void:
	lives -= 1
	lives_display.text = "LIVES: " + str(lives)
	if lives == 0:
		get_tree().paused = true
		feedback_display.visible = false
		var menu = game_over_menu.instantiate()
		menu.score = score
		add_child(menu)


func _on_settings_pressed() -> void:
	var settings = settings_menu.instantiate()
	pause_menu.visible = false
	settings.main = self
	add_child(settings)


func show_feedback(text: String) -> void:
	feedback_display.visible = true
	feedback_display.text = text
	timer.start()


# Decreases score when an item falls off the end of the conveyer
func _on_end_body_entered(body: Node3D) -> void:
	body.call_deferred("queue_free")
	change_score(-ITEM_VALUE)


# Makes the feedback display hide when the timer goes ends
func _on_feedback_timer_timeout() -> void:
	feedback_display.visible = false


## Increases the time display
func _on_level_timer_timeout() -> void:
	time += 1
	var minutes = str(int(time / 60.0))
	var seconds = str(time % 60)
	
	# Format time
	if len(seconds) == 1:
		seconds = "0" + seconds
	if len(minutes) == 1:
		minutes = "0" + minutes
	time_display.text = minutes + ":" + seconds


func _change_speed(factor: float):
	for conveyer in get_tree().get_nodes_in_group("conveyers"):
		conveyer.speed *= factor
	spawner.time /= factor
	arm.speed *= factor
