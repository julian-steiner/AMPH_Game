class_name Cage
extends StaticBody2D

var button = load("res://UserInterface/Menü_Button.tscn").instance();

func _on_Area2D_body_entered(body):
	if body is FlyingCharakter:
		if body.key > 0:
			$AnimatedSprite2.play("away")
			get_tree().paused = true
			get_parent().add_child(button)
		else:
			body.zero_key = true
