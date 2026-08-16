extends Control

@export var arm_material : Material 
@export var colour_picker : Node 
@export var sound_toggle : Node
@export var music_toggle : Node

var level: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colour_picker.color = Global.settings["colour"]
	sound_toggle.set_pressed_no_signal(Global.settings["sound"])
	music_toggle.set_pressed_no_signal(Global.settings["music"])


## closes the settings menu
func _on_exit_pressed() -> void:
	level.pause_game()
	call_deferred("queue_free")
	Global.save_data()
	

## changes and saves the colour of the arm
func _set_colour(color: Color) -> void:
	arm_material.albedo_color = color
	Global.settings["colour"] = color


func _on_sound_toggled(toggled_on: bool) -> void:
	Global.settings["sound"] = toggled_on


func _on_music_toggled(toggled_on: bool) -> void:
	Global.settings["music"] = toggled_on
	if toggled_on == true:
		level.audio_player.playing = true
	else:
		level.audio_player.playing = false
