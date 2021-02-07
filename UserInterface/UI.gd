extends Control

var level_assassin = 1
var level_bat = 1

var c_character = "assassin"

# 0 = nothing, 1 = character, 2 = all
var finished_stage = 0

#func preload_levels():
#	preload("res://Levels//Character_Levels//Level_1.tscn")
#	preload("res://Levels//Character_Levels//Level_2.tscn")
#	preload("res://Levels//Flying_Levels//Level_1.tscn")
#	preload("res://Levels//Flying_Levels//Level_2.tscn")
#	preload("res://Levels//Flying_Levels//Level_3.tscn")
#	preload("res://Levels//Flying_Levels//Level_4.tscn")

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
#	preload_levels();
	var data = load_data()
	level_assassin = data.get("level_assassin")
	level_bat = data.get("level_bat")
	finished_stage = data.get("finished_stage")
	
	if finished_stage != 2:
		$Sprites/Bat_Lock.play("Closed")
	if finished_stage != 0:
		$Sprites/Character_Lock.play("Closed")
		

func _on_Start_Button_pressed():
	print(finished_stage, c_character)
	if finished_stage == -1:
		save_data();
		get_tree().change_scene("res://Tutorial/Character/Tutorial_1.tscn")
	if finished_stage == 1:
		save_data();
		get_tree().change_scene("res://Tutorial/FlyingCharacter/Tutorial_1.tscn")
	if c_character == "assassin" and finished_stage == 0:
		print("Loading character level")
		save_data();
		get_tree().change_scene("res://Levels//Character_Levels//Level_" + str(level_assassin) + ".tscn")
	elif c_character == "bat" and finished_stage == 2:
		save_data();
		get_tree().change_scene("res://Levels//Flying_Levels//Level_" + str(level_bat) + ".tscn")

func _on_Assassin_select_Button_pressed():
	$Buttons/Button_Sound.play();
	c_character = "assassin"

func _on_Bat_select_Button_pressed():
	$Buttons/Button_Sound.play();
	c_character = "bat"

func _on_Reset_Button_pressed():
	$Buttons/Button_Sound.play();
	level_assassin = 1
	level_bat = 1
	finished_stage = -1
	save_data()
	get_tree().change_scene("res://UserInterface/UI.tscn")

func _on_Tutorial_Button_pressed():
	if c_character == "assassin":
		save_data();
		get_tree().change_scene("res://Tutorial/Character/Tutorial_1.tscn")
	elif c_character == "bat":
		save_data();
		get_tree().change_scene("res://Tutorial/FlyingCharacter/Tutorial_1.tscn")

