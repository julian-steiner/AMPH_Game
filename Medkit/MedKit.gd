class_name MedKit
extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter:
		if body.hp != 100 and not body.hp <= 0:
			body.hp = 100
			queue_free()
