extends Node3D

@export var target_area: Node
@export var conveyor_area: Node
@export var animated_mesh: Node
@onready var material = animated_mesh.get_surface_override_material(0)

const DIRECTION = Vector3(0, 0, 1)
const SPEED: float = 5.0 ## The speed of the items
const OFFSET_SPEED: float = -1.25 # How fast the conveyer belt texture moves 


## Returns the first item on the conveyer to be grabbed
func grab_item():
	var bodies = target_area.get_overlapping_bodies()
	if bodies:
		return bodies[0]


func _physics_process(delta: float) -> void:
	# Move items forward
	var bodies = conveyor_area.get_overlapping_bodies()
	for body in bodies:
		body.position += DIRECTION * SPEED * delta
		
	# Move conveyer belt texture
	material.uv1_offset.x += OFFSET_SPEED * delta
	
	
