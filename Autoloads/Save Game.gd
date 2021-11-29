extends Node

const FILE_PATH: String = "user://game_data"

var data: Dictionary = {}

func save_data() -> void:
	var file: File = File.new()
	file.open(FILE_PATH, File.WRITE)
	file.store_var(data)
	file.close()
	

func load_data() -> void:
	var file: File = File.new()
	if file.file_exists(FILE_PATH):
		file.open(FILE_PATH, File.READ)
		data = file.get_var()
		file.close()
	else:
		printerr("data file not found")
