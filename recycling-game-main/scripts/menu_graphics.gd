extends Node3D


@export var path_follow: Node
@export var spawner: Node
const START_ITEMS: int = 5 ## The number of items that start on the conveyer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Spawn items on the conveyer
	for item in START_ITEMS:
		path_follow.progress_ratio = item / float(START_ITEMS)
		spawner.spawn_item(path_follow.global_position)


# Remove items at the end of the conveyer
func _on_area_3d_body_entered(body: Node3D) -> void:
	body.call_deferred("queue_free")
