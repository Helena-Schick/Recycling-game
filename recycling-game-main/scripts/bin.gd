extends Node3D

@export var bin_number: int
@export var level: Node
const bin_names: Array = ["rubbish", "compost", "recycling", "soft plastics"]


# Called when an item is droopped in the bin
func _on_area_3d_body_entered(item: Node3D) -> void:
	if item.bin == bin_number: # Correct bin
		level.change_score(level.ITEM_VALUE)
	else:
		level.change_score(-level.ITEM_VALUE)
		level.show_feedback("That should go in the " + bin_names[item.bin] + " bin!")
		level.decrease_lives()
	item.call_deferred("queue_free")
