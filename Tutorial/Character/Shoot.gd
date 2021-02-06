class_name Shoot
extends Node2D

func _on_Shoot_body_entered(body):
	if body is Character:
		body.Shoot = true
		body.show = 100
		queue_free()
