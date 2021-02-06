class_name cach_game
extends Node

var button = load("res://UserInterface/Menü_Button.tscn").instance();

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
