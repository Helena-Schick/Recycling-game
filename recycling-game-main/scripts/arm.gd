extends Node3D

@export var ik : Node ## the inverse kinematics node
@export var rest : Node ## the rest position for the arm
@export var level : Node ## the root node for the level scene
@export var marker : Node ## the marker for the position of the claw
@export var armature : Node ## the armature for the arm
@export var animation : Node ## the animation player for the claw
@export var ik_target : Node ## the target for inverse kinematics
@export var bin_markers : Array[Marker3D] ## an array of marker3Ds for the bins 

const SPEED : float = 15.0
const Y_MOVEMENT_SCALE : int = 3

var target_pos
var target_item
var grabbed_item
var target_bin : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ik.start() # start inverse kinematics
	target_item = rest 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_item:
		target_pos = target_item.global_position
		var dir = abs(marker.global_position.direction_to(target_pos))
		
		if grabbed_item: # move up faster when holding an item
			# prevents the arm from colliding with the bins
			dir.y = dir.y * Y_MOVEMENT_SCALE
		
		# move marker towards target item
		var marker_pos = marker.global_position
		marker.global_position.x = move_toward(marker_pos.x, target_pos.x, SPEED * delta * dir.x)
		marker.global_position.y = move_toward(marker_pos.y, target_pos.y, SPEED * delta * dir.y)
		marker.global_position.z = move_toward(marker_pos.z, target_pos.z, SPEED * delta * dir.z)
		
		# check if the target has been reached
		if marker.global_position == target_pos:
			_reached_target()
	
	# move and rotate the arm to the position of the marker
	ik_target.position.y = marker.position.y
	ik_target.position.x = sqrt(pow(marker.position.x, 2) + pow(marker.position.z, 2))
	armature.rotation.y = atan2(-marker.position.z, marker.position.x)


func _reached_target() -> void:
	# pick up rubbish item
	if target_item.is_in_group("rubbish_items"):
		target_item.reparent(marker, true)
		grabbed_item = target_item
		target_item.sleeping = true
		target_item = bin_markers[target_bin] # new target
		animation.play("close_claw")
	
	# drop item in bin
	elif target_item in bin_markers:
		grabbed_item.reparent(level, true)
		grabbed_item.sleeping = false
		grabbed_item = null
		target_item = rest # new target
		animation.play("open_claw")
