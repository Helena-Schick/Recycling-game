extends Node3D

@export var bin_number: bin_type
@export var level: Node
enum bin_type { RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS }


# Called when an item is droopped in the bin
func _on_area_3d_body_entered(item: Node3D) -> void:
	if item.bin == bin_number: # Correct bin
		level.change_score(level.ITEM_VALUE)
	else:
		level.change_score(-level.ITEM_VALUE)
		level.show_feedback(item.text)
	item.call_deferred("queue_free")
