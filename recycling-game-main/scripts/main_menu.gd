extends Control


## start the game
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")


## close the game
func _on_exit_pressed() -> void:
	get_tree().call_deferred("quit")
