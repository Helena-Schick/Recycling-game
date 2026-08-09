extends Node

@export var conveyor_area: Node
var speed: float = 5.0


func _physics_process(delta: float) -> void:
	# Move items in circular arc
	var items = conveyor_area.get_overlapping_bodies()
	for item in items:
		var relative_pos = item.global_position - self.global_position
		item.position += Vector3(relative_pos.z, 0, -relative_pos.x).normalized() * speed * delta 
