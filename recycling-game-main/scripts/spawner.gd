extends Node3D

@export var timer : Node
@export var item_scene : PackedScene

var items : Array[ItemData]

var time : float = 2.0
var randomness : float = 0.8
var size : float = 1.3
 

func _ready() -> void:
	for item in Array(DirAccess.get_files_at("res://assets/items/")):
		if item.ends_with(".tres"):
			items.append(load("res://assets/items/" + item))


func _on_timer_timeout() -> void:
	# restart timer 
	timer.wait_time = time + randf_range(-0.5, 0.5) * randomness * time
	timer.start()


	# spawn item
	var item = item_scene.instantiate()
	
	item.data = items.pick_random()
	item.position = position + Vector3(randf_range(-size, size), 0, 0)
	
	item.add_to_group("rubbish_items")
	add_sibling(item)
