class_name Cage
extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body is FlyingCharakter:
		if body.key > 0:
			$AnimatedSprite2.play("away")
		else:
			body.zero_key = true
