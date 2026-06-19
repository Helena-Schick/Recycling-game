extends Control

@export var arm_material : Material 
@export var colour_picker : Node 
var main : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colour_picker.color = Global.colour


## closes the settings menu
func _on_exit_pressed() -> void:
	main.open_pause_menu()
	call_deferred("queue_free")


## changes and saves the colour of the arm
func _set_colour(color: Color) -> void:
	arm_material.albedo_color = color
	Global.colour = color
	Global.save_data()
