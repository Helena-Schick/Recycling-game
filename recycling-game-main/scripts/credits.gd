extends Control


## Close the credits menu
func _on_exit_pressed() -> void:
	call_deferred("queue_free")
