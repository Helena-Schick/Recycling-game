extends Node3D

@export var area : Node

const DIRECTION = Vector3(0, 0, 1)
const SPEED = 5

func grab_item():
	var bodies = area.get_overlapping_bodies()
	if bodies:
		return bodies[0]


func _on_area_3d_body_entered(body: Node3D) -> void:
	body.velocity = DIRECTION * SPEED
