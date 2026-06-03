extends Node3D
@export var bin_number : int
@export var level : Node


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.bin == bin_number:
		level.change_score(1)
	else:
		level.change_score(-1)
	body.call_deferred("queue_free")
