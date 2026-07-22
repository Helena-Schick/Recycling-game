extends Node3D

@export var ik : Node ## the inverse kinematics node
@export var rest : Node ## the rest position for the arm
@export var level : Node ## the root node for the level scene
@export var marker : Node ## the marker for the position of the claw
@export var armature : Node ## the armature for the arm
@export var animation : Node ## the animation player for the claw
@export var ik_target : Node ## the target for inverse kinematics
@export var bin_markers : Array[Marker3D] ## an array of markers for the bins 

const SPEED : float = 15.0
const Y_MOVEMENT_SCALE : int = 3

var target_pos ## the position the arm is moving to
var target_item ## the item or node the arm is moving to
var grabbed_item ## the item currently being held by the arm, or null if no item
var target_bin : int ## the bin the arm is moving to


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
	armature.rotation.y = atan2(-marker.position.z, marker.position.x)
	ik_target.global_position = marker.global_position


func _reached_target() -> void:
	# pick up rubbish item
	if target_item.is_in_group("rubbish_items"):
		target_item.reparent(marker, true)
		grabbed_item = target_item
		target_item.sleeping = true
		target_item = bin_markers[target_bin] # move to selected bin
		animation.play("close_claw")
	
	# drop item in bin
	elif target_item in bin_markers:
		grabbed_item.reparent(level, true)
		grabbed_item.sleeping = false
		grabbed_item = null
		target_item = rest # move to rest position
		animation.play("open_claw")
