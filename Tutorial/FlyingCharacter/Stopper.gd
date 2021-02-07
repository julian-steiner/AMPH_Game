extends Node2D

func _on_Stopper_body_entered(body):
	if body is FlyingCharakter:
		body.Stopper = true
		body.show = 200
		queue_free()
