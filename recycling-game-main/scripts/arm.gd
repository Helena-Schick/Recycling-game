extends Node3D
@export var ik : Node
@export var marker : Node
@export var ik_target : Node
@export var armature : Node
@export var rest : Node
@export var bin_markers : Array[Node]
@export var level : Node
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
	movement(delta)


func movement(delta: float) -> void:
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
			
	# move the arm to the position of the marker
	ik_target.position.y = marker.position.y
	ik_target.position.x = sqrt(pow(marker.position.x, 2) + pow(marker.position.z, 2))
	armature.rotation.y = atan2(-marker.position.z, marker.position.x)


func _reached_target() -> void:
	if target_item.is_in_group("rubbish_items"):
		# pick up rubbish item
		target_item.reparent(marker, true)
		grabbed_item = target_item
		target_item.sleeping = true
		
		target_item = bin_markers[target_bin] # new target
	elif target_item in bin_markers:
		# drop item
		grabbed_item.reparent(level, true)
		grabbed_item.sleeping = false
		grabbed_item = null
		target_item = rest # new target
