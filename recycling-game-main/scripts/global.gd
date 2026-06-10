extends Node

var save_path: String = "user://save_data.save"
var colour: Color


func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(colour)
	

func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		colour = file.get_var()
	else:
		colour = Color("#22d5ff")
