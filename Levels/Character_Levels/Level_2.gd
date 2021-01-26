extends Node2D

var level_assassin = 2
var level_bat = 0

func save_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.WRITE)
	c_file.store_line(to_json(level_assassin))
	c_file.store_line(to_json(level_bat))
	c_file.close()
	
func load_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.READ)
	var level_assassin = int(c_file.get_line())
	var level_bat = int(c_file.get_line())
	c_file.close()
	return {"level_assassin": level_assassin, "level_bat": level_bat}

func _ready():
	var data = load_data();
	level_bat = data.get("level_bat");
	save_data();
