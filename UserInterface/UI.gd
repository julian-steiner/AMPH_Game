extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var config = File.new()
	config.open("res://game_information.save", File.WRITE);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var level_number = 1

func _on_Start_Button_pressed():
	get_tree().change_scene("res://Levels/Charakter_Levels/Level_" + str(level_number) + ".tscn")


func _on_Continue_Button_pressed():
	pass # Replace with function body.


func _on_Assassin_select_Button_pressed():
	pass # Replace with function body.


func _on_Bat_select_Button_pressed():
	pass # Replace with function body.
=======
	get_tree().change_scene("res://Levels/Flying_Levels/Level_" + str(level_number) + ".tscn")
>>>>>>> develop
