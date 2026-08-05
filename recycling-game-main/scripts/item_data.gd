extends Resource
class_name ItemData

enum bin_type { RUBBISH, COMPOST, RECYCLING, SOFT_PLASTICS }

@export var bin: bin_type ## The bin that the item should go into
@export var mesh: Resource ## The mesh resource for the item
@export var scale: Vector3 = Vector3(1, 1, 1) ## The size of the mesh
@export var rotation: Vector3 = Vector3(0, 0, 0) ## The rotation of the mesh
@export var height: float = 1.0 ## The height of the collision shape
@export var text: String ## The text to be displayed as faadback
