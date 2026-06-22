extends Node3D

@export var timer : Node
@export var item_scene : PackedScene
@export var items : Array[ItemData]
@export var test : ItemData

var time : float = 2.0
var randomness : float = 0.8
var size : float = 1.3


func _on_timer_timeout() -> void:
	# restart timer 
	timer.wait_time = time + randf_range(-0.5, 0.5) * randomness * time
	timer.start()
	
	# spawn item
	var item = item_scene.instantiate()
	
	item.data = items[randi_range(0, items.size() - 1)]
	item.position = position + Vector3(randf_range(-size, size), 0, 0)
	
	item.add_to_group("rubbish_items")
	add_sibling(item)
