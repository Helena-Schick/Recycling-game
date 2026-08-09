extends Conveyer

@export var target_area: Node


## Returns the first item on the conveyer to be grabbed
func grab_item():
	var bodies = target_area.get_overlapping_bodies()
	if bodies:
		return bodies[0]
