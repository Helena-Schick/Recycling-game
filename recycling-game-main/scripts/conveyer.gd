extends Node3D

@export var target_area : Node
@export var conveyor_area : Node
const DIRECTION = Vector3(0, 0, 1)
const SPEED = 5


func grab_item():
	var bodies = target_area.get_overlapping_bodies()
	if bodies:
		return bodies[0]


func _physics_process(delta: float) -> void:
	var bodies = conveyor_area.get_overlapping_bodies()
	for body in bodies:
		body.position += DIRECTION * SPEED * delta
