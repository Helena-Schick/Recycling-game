extends Node3D

@export var timer: Node
@export var item_scene: PackedScene

var items: Array[ItemData]
var time: float = 2.0
var randomness: float = 0.4

const SIZE: float = 1.3 # The size of the area where items spawn
const items_folder: String = "res://assets/items/" ## The path to the folder of item data


func _ready() -> void:
	for item in Array(DirAccess.get_files_at(items_folder)):
		if item.ends_with(".tres"):
			items.append(load(items_folder + item))


# Spawns the item when the timer goes off
func _on_timer_timeout() -> void:
	# restart timer 
	timer.wait_time = time + randf_range(-1, 1) * randomness * time
	timer.start()
	
	# spawn item
	var item = item_scene.instantiate()
	item.data = items.pick_random()
	item.position = position + Vector3(randf_range(-SIZE, SIZE), 0, 0)
	
	item.add_to_group("rubbish_items")
	add_sibling(item)
