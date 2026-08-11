extends Node3D

@export var timer: Node
@export var item_scene: PackedScene

var items: Array[ItemData]
var time: float = 1.8 ## The average time for each item to spawn
var randomness: float = 0.4

const SIZE: float = 1.3 ## The size of the area where items spawn
const items_folder: String = "res://assets/items/" ## The path to the folder of item data
const TIME_CHANGE: float = 0.13 ## How much the time value decreases by


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the item data from the items folder
	for item in Array(DirAccess.get_files_at(items_folder)):
		if item.ends_with(".tres"):
			items.append(load(items_folder + item))


## Spawns the item when the timer goes off
func _on_timer_timeout() -> void:
	# restart timer 
	timer.wait_time = time + randf_range(-1, 1) * randomness * time
	timer.start()
	
	var item_position = global_position + Vector3(randf_range(-SIZE, SIZE), 0, 0)
	spawn_item(item_position)


## Spawns item in a given position
func spawn_item(item_position: Vector3) -> void:
	var item = item_scene.instantiate()
	item.data = items.pick_random()
	item.position = item_position
	
	item.add_to_group("rubbish_items")
	add_sibling.call_deferred(item)
