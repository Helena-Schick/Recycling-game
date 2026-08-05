extends Control


## Start the game
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")


## Close the game
func _on_exit_pressed() -> void:
	get_tree().call_deferred("quit")


## Open the credits screen
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
