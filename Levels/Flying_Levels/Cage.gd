class_name Cage
extends StaticBody2D

var button = load("res://UserInterface/Menü_Button.tscn").instance();

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

		else:
			body.zero_key = true
			body.zero_key_show = 100
