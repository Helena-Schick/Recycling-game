extends Node3D

@export var bin_number : bin_type
@export var level : Node

enum bin_type {RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS}


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.bin == bin_number:
		level.change_score(1)
	else:
		level.change_score(-1)
		level.show_feedback(body.text)
	body.call_deferred("queue_free")
