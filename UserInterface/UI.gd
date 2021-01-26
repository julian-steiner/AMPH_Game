extends Control

var level_assassin = 1
var level_bat = 1

var c_character = "0"

func save_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.WRITE)
	c_file.store_line(to_json(level_assassin))
	c_file.store_line(to_json(level_bat))
	c_file.close()
	
func load_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.READ)
	var level_assassin = c_file.get_line()
	var level_bat = c_file.get_line()
	c_file.close()
	return {"level_assassin": level_assassin, "level_bat": level_bat}

func _ready():
	var data = load_data()
	level_assassin = data.get("level_assassin")
	level_bat = data.get("level_bat")

var level_number = 1

func _on_Start_Button_pressed():
	print(c_character)
	if c_character == "assassin":
		get_tree().change_scene("res://Levels//Character_Levels//Level_" + str(level_assassin) + ".tscn")
	elif c_character == "bat":
		get_tree().change_scene("res://Levels//Flying_Levels//Level_" + str(level_bat) + ".tscn")
	

func _on_Continue_Button_pressed():
	pass

func _on_Assassin_select_Button_pressed():
	c_character = "assassin"

func _on_Bat_select_Button_pressed():
	c_character = "bat"

