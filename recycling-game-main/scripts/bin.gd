extends Node3D
@export var bin_number : int


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.bin == bin_number:
		print("yay")
	else:
		print("not yay")
	#body.call_deferred("queue_free")
