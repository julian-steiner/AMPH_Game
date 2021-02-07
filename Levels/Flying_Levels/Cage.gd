class_name Cage
extends StaticBody2D

var level_assassin = 4
var level_bat = 4
var c_character = "bat"
var finished_stage = 2

var button = load("res://UserInterface/Menü_Button.tscn").instance();

func save_data():
	var c_file = File.new();
	c_file.open("res://game_information.save", File.WRITE)
	c_file.store_line(to_json(level_assassin))
	c_file.store_line(to_json(level_bat))
	c_file.store_line(to_json(c_character))
	c_file.store_line(to_json(finished_stage))
	c_file.close()

func _on_Area2D_body_entered(body):
	if body is FlyingCharakter:
		if body.key > 0:
			$AnimatedSprite2.play("away")
			$AnimatedSprite.stop()
			body.moving = false
			body.finnishedGame = true
			get_parent().add_child(button)
			if get_parent().get_node("Enemys/Enemy23") != null:
				get_parent().get_node("Enemys/Enemy23").moving = false
			if get_parent().get_node("Enemys/Enemy22") != null:
				get_parent().get_node("Enemys/Enemy22").moving = false
				
			save_data()

		else:
			body.zero_key = true
			body.zero_key_show = 100
