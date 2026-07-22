extends Node3D

enum bin_type {RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS}

@export var mesh_instance : Node
@export var collision_shape : Node
@export var data : ItemData

var bin : int
var mesh : Resource
var size : Vector3
var text : String

const ANGLE = PI / 4

func _ready() -> void:
	mesh_instance.mesh = data.mesh
	bin = data.bin
	text = data.text
	mesh_instance.rotation = data.rotation
	mesh_instance.rotation.y += randf_range(-ANGLE, ANGLE)
	mesh_instance.scale = data.scale
	collision_shape.shape.size.y = data.height
