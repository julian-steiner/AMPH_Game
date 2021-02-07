extends Node2D

var level_assassin = 1
var level_bat = 4
var c_character = 0
var finished_stage = 1

func save_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.WRITE)
	c_file.store_line(to_json(level_assassin))
	c_file.store_line(to_json(level_bat))
	c_file.store_line(to_json(c_character))
	c_file.store_line(to_json(finished_stage))
	c_file.close()
	
func load_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.READ)
	var level_assassin = int(c_file.get_line())
	var level_bat = int(c_file.get_line())
	var c_character = c_file.get_line().replace("\"", "");
	var finished_stage = c_file.get_line()
	c_file.close()
	return {"level_assassin": level_assassin, "level_bat": level_bat, "c_character": c_character, "finished_stage": finished_stage}

func dynamic_zooming():
	var window_size = OS.window_size
	get_node("FlyingCharakter/Camera2D").zoom = Vector2(1024 / window_size.x  , 600 / window_size.y)

func _ready():
	var data = load_data();
	level_assassin = data.get("level_assassin");
	c_character = data.get("c_character");
	print(c_character)
	save_data();
	dynamic_zooming()

func _on_Area2D_body_entered(body):
	if body is FlyingCharakter:
		get_tree().change_scene("res://Levels//Flying_Levels//Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
