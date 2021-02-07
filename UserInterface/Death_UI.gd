extends Control

var level_assassin = 0
var level_bat = 0
var c_character = 0
var finished_stage = 0

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
	var finished_stage = int(c_file.get_line())
	c_file.close()
	return {"level_assassin": level_assassin, "level_bat": level_bat, "c_character": c_character, "finished_stage": finished_stage}

func _ready():
	var data = load_data();
	level_assassin = data.get("level_assassin")
	level_bat = data.get("level_bat")
	c_character = data.get("c_character")
	finished_stage = data.get("finished_stage")
	print(data)

func _on_Menu_button_pressed():
	$Buttons/Button_Sound.play();
	get_tree().change_scene("res://UserInterface/UI.tscn")

func _on_Continue_button_pressed():
	if c_character == "assassin":
		save_data();
		get_tree().change_scene("res://Levels//Character_Levels//Level_" + str(level_assassin) + ".tscn")
	elif c_character == "bat":
		save_data();
		get_tree().change_scene("res://Levels//Flying_Levels//Level_" + str(level_bat) + ".tscn")

