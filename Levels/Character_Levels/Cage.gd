class_name cach_game
extends Node

var level_assassin = 4
var level_bat = 0
var c_character = "assassin"
var finished_stage = 1

var button = load("res://UserInterface/Menü_Button.tscn").instance();

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

func _on_Area2D_body_entered(body):
	if body is Character:
		$AnimatedSprite.play("cage")
		$AnimatedSprite2.play("hier")
		$AnimatedSprite3.play("hier")
		body.moving = false
		body.finnishedGame = true
		get_parent().add_child(button)
		print("after")
		button.transform[2] = Vector2(4295.07 + 300, -3137.31 + 200)
		print("geil")
		if get_parent().get_node("Enemys/Enemy23") != null:
			get_parent().get_node("Enemys/Enemy23").moving = false
		var data = load_data()
		level_bat = data.get("level_bat")
		save_data()
