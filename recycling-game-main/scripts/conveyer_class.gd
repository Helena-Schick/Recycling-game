class_name Conveyer
extends Node3D

@export var conveyor_area: Node
@export var animated_mesh: Node
@onready var material = animated_mesh.get_surface_override_material(0)
@onready var direction : Vector3 = Vector3(0, 0, 1).rotated(Vector3.UP, rotation.y)


const OFFSET_SPEED: float = -0.25 # How fast the conveyer belt texture moves 
var speed: float = 6.7 ## The speed of the items


func move_items(delta: float) -> void:
	# Move items forward
	var bodies = conveyor_area.get_overlapping_bodies()
	for body in bodies:
		body.position += direction * speed * delta
		
	# Move conveyer belt texture
	material.uv1_offset.x += OFFSET_SPEED * delta * speed


func _physics_process(delta: float) -> void:
	move_items(delta)
