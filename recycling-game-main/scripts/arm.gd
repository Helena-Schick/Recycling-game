extends Node3D
@export var ik : Node
@export var marker : Node
@export var ik_target : Node
@export var armature : Node
@export var rest : Node
@export var marker_1 : Node
@export var level : Node
const SPEED : float = 20.0
var target_pos
var target_item
var grabbed_item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ik.start() # start inverse kinematics
	target_item = rest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta)


func movement(delta: float) -> void:
	# move marker towards target item
	if target_item:
		target_pos = target_item.global_position
		marker.global_position.x = move_toward(marker.global_position.x, target_pos.x, SPEED * delta)
		marker.global_position.y = move_toward(marker.global_position.y, target_pos.y, SPEED * delta)
		marker.global_position.z = move_toward(marker.global_position.z, target_pos.z, SPEED * delta)
		
		# check if the target has been reached
		if marker.global_position == target_pos:
			_reached_target()
			
	# move the arm to the position of the marker
	ik_target.position.y = marker.position.y
	ik_target.position.x = sqrt(pow(marker.position.x, 2) + pow(marker.position.z, 2))
	armature.rotation.y = atan2(-marker.position.z, marker.position.x)


func _reached_target() -> void:
	if target_item.is_in_group("rubbish_items"):
		# pick up rubbish item
		target_item.reparent(marker, true)
		grabbed_item = target_item
		target_item.gravity_scale = 0
		target_item.velocity = Vector3(0, 0, 0)
		
		target_item = marker_1 # new target
	elif target_item == marker_1:
		# drop item
		grabbed_item.reparent(level, true)
		grabbed_item.gravity_scale = 1
		grabbed_item.velocity = Vector3(0, 0, 0)
		
		target_item = rest # new target
