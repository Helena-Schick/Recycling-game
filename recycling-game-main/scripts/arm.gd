extends Node3D
@export var ik : Node
@export var marker : Node
@export var ik_target : Node
@export var armature : Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ik.start() # start inverse kinematics


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		marker.global_position.x -= delta * 20
	if Input.is_action_pressed("ui_right"):
		marker.global_position.x += delta * 20
	if Input.is_action_pressed("ui_up"):
		marker.global_position.z -= delta * 20
	if Input.is_action_pressed("ui_down"):
		marker.global_position.z += delta * 20
	
	# move the arm to the position of the marker
	ik_target.position.y = marker.position.y
	ik_target.position.x = sqrt(pow(marker.position.x, 2) + pow(marker.position.z, 2))
	armature.rotation.y = atan2(-marker.position.z, marker.position.x)
