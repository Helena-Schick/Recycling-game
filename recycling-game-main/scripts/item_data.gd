extends Resource
class_name ItemData

enum bin_type {RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS}

@export var bin : bin_type ## the bin that the item should go into
@export var mesh : Resource ## the mesh resource for the item
@export var scale : Vector3 = Vector3(1, 1, 1) ## the size of the mesh
@export var rotation : Vector3 = Vector3(0, 0, 0) ## the rotation of the mesh
@export var height : float = 1.0 ## the height of the collision shape
@export var text : String ## the text to be displayed as faadback
