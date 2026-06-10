extends Node3D

@export var timer : Node
@export var item_scene : PackedScene
@export var mesh : Array[Mesh]
@export var bin_num : Array[int]

var time : float = 2.0
var randomness : float = 0.8
var size : float = 1.3


func _on_timer_timeout() -> void:
	# start timer again
	timer.wait_time = time + randf_range(-0.5, 0.5) * randomness * time
	timer.start()
	
	# spawn item
	var scene = item_scene.instantiate()
	var item_index = randi_range(0, mesh.size() - 1)
	scene.bin = bin_num[item_index]
	scene.mesh = mesh[item_index]
	scene.position = position + Vector3(randf_range(-size, size), 0, randf_range(-size, size))
	scene.add_to_group("rubbish_items")
	add_sibling(scene)
