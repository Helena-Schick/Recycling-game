extends Control
@export var main : PackedScene


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(main)


func _on_exit_pressed() -> void:
	get_tree().call_deferred("quit")
