extends Control

@export var level_scene: String
@export var main_menu: PackedScene
@export var score_display: Node

var score: int ## The final score 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_display.text = str(score)


func _on_play_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(level_scene)
	call_deferred("queue_free")


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
	call_deferred("queue_free")
