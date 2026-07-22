extends Control
@export var menu : PackedScene


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_packed(menu)
