extends Node

@export var conveyor_area: Node ## The area3D that detects items
var speed: float = 6.7 ## The speed the items move down the conveyer


func _physics_process(delta: float) -> void:
	# Move items in circular arc
	var items = conveyor_area.get_overlapping_bodies()
	for item in items:
		var relative_pos = item.global_position - self.global_position
		item.position += Vector3(relative_pos.z, 0, -relative_pos.x).normalized() * speed * delta 


func _on_item_entered(body: Node3D) -> void:
	if body.has_meta("item"):
		body.on_corner = true


func _on_item_exited(body: Node3D) -> void:
	if body.has_meta("item"):
		body.on_corner = false
