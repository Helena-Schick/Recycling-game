extends Node3D
var bin : int
var mesh : Resource

func _ready() -> void:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	add_child(mesh_instance)
