extends Control

@export var level_scene: String
@export var main_menu: PackedScene
@export var score_display: Node
@export var high_score_display: Node

var score: int ## The final score 
var high_score

const SCORE_TEXT: String = "SCORE: "
const HIGH_SCORE_TEXT: String = "HIGH SCORE: "


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get high score
	if Global.settings.has("high_score"):
		high_score = Global.settings["high_score"]
	else:
		high_score = 0
		
	if score > high_score: # Set new high score
		high_score = score
		Global.settings["high_score"] = score
		Global.save_data()
		
	score_display.text = SCORE_TEXT + str(score)
	high_score_display.text = HIGH_SCORE_TEXT + str(high_score)


func _on_play_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(level_scene)
	call_deferred("queue_free")


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
	call_deferred("queue_free")
