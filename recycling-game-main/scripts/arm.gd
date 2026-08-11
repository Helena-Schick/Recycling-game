extends Node3D

@export var ik: Node ## The inverse kinematics node
@export var rest: Node ## The rest position for the arm
@export var level: Node ## The root node for the level scene
@export var marker: Node ## The marker for the position of the claw
@export var camera_c: Node ## The 3rd camera
@export var armature: Node ## The armature for the arm
@export var animation: Node ## The animation player for the claw
@export var ik_target: Node ## The target for inverse kinematics
@export var bin_markers: Array[Marker3D] ## An array of markers for the bins 

const MAX_SPEED: float = 30.0 ## The maximun speed of the arm
const Y_MOVEMENT_SCALE: float = 3.0 ## How much faster the arm needs to move upward
const SPEED_CHANGE: float = 1.5 ## How much the speed increases by 

var speed: float = 18.0 ## The speed at which the arm moves
var target_pos ## The position the arm is moving to
var target_item ## The item or node the arm is moving to
var grabbed_item ## The item currently being held by the arm, or null if no item
var target_bin: int ## The bin the arm is moving to


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ik.start() # Start inverse kinematics
	target_item = rest 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_item:
		target_pos = target_item.global_position
		var dir = abs(marker.global_position.direction_to(target_pos))
		
		if grabbed_item: # Move up faster when holding an item
			# This prevents the arm from colliding with the bins
			dir.y = dir.y * Y_MOVEMENT_SCALE
		
		# Move marker towards target item
		var marker_pos = marker.global_position
		marker.global_position.x = move_toward(marker_pos.x, target_pos.x, speed * delta * dir.x)
		marker.global_position.y = move_toward(marker_pos.y, target_pos.y, speed * delta * dir.y)
		marker.global_position.z = move_toward(marker_pos.z, target_pos.z, speed * delta * dir.z)
		
		# Check if the target has been reached
		if marker.global_position == target_pos:
			_reached_target()
	
	# Move and rotate the arm to the position of the marker
	armature.rotation.y = atan2(-marker.position.z, marker.position.x)
	ik_target.global_position = marker.global_position


# Called when the arm reaches the target position
func _reached_target() -> void:
	# Pick up rubbish item
	if target_item.is_in_group("rubbish_items"):
		target_item.reparent(marker, true)
		grabbed_item = target_item
		target_item.sleeping = true
		target_item = bin_markers[target_bin] # Move to selected bin
		animation.play("close_claw")
	
	# Drop item in bin
	elif target_item in bin_markers:
		grabbed_item.reparent(level, true)
		grabbed_item.sleeping = false
		grabbed_item = null
		target_item = rest # Move to rest position
		animation.play("open_claw")
