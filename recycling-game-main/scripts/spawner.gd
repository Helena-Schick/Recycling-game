extends Node3D
var time : float = 3.0
var randomness : float = 0.5
@export var timer : Node
@export var scenes : Array[PackedScene]


func _on_timer_timeout() -> void:
	# start timer again
	timer.wait_time = time + randf_range(-0.5, 0.5) * randomness
	timer.start()
	
	# spawn item
	var index = randi_range(0, scenes.size() - 1)
	var scene = scenes[index].instantiate()
	scene.position = position
	scene.add_to_group("rubbish_items")
	add_sibling(scene)
	
	
