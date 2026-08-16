extends Node3D

enum bin_type {RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS}

@export var mesh_instance: Node
@export var collision_shape: Node
@export var data: ItemData ## The data for the item

const ANGLE: float = PI / 4
const TIP_ANGLE: float = PI / 2

var bin: int
var mesh: Resource
var size: Vector3
var text: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh_instance.mesh = data.mesh
	bin = data.bin
	
	# Set size and rotation
	mesh_instance.rotation = data.rotation
	rotation.y += randf_range(-ANGLE, ANGLE)
	mesh_instance.scale = data.scale
	collision_shape.shape.size.y = data.height
	mesh_instance.position.y = -data.height / 2
	
	# Set random rotation so item can fall on it's side
	if data.tip_over: 
		rotation.x = randf_range(0, TIP_ANGLE)
	
