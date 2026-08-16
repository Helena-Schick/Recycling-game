extends Control

@export var level_scene: String
@export var credits_scene: String
@export var audio_player: Node


func _ready() -> void:
	Global.load_data()
	var music = Global.settings["music"]
	if music == false:
		audio_player.playing = false


## Start the game
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(level_scene)


## Close the game
func _on_exit_pressed() -> void:
	get_tree().call_deferred("quit")


## Open the credits screen
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene)
