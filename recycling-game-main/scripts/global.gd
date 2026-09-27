extends Node

var save_path: String = "user://save_data.save"
var shown_tutorial : bool = false ## Whether the tutorial has already been shown
var settings = {
	"colour" : Color("#22d5ff"),
	"sound" : true,
	"music" : true,
	"high_score" : 0
}


## Saves the settings for the game
func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(settings)


## Loads the settings for the game
func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		settings = file.get_var()
