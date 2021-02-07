extends Node2D

func _on_AttakNum_body_entered(body):
	if body is FlyingCharakter:
		body.AttakNum = true
		body.show = 200
		queue_free()
