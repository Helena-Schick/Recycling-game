extends Node3D

@export var mesh_instance : Node
var bin : int
var mesh : Resource


func _ready() -> void:
	mesh_instance.mesh = mesh
