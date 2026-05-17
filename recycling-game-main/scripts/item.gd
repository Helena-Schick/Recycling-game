extends Node3D
@export var bin : int
var velocity = Vector3(0, 0, 0)


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta
