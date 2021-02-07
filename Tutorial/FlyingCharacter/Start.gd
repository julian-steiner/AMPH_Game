extends Node2D

func _on_Start_body_entered(body):
	if body is FlyingCharakter:
		body.moving = false
		body.start = true
		body.show = 200
		queue_free()
