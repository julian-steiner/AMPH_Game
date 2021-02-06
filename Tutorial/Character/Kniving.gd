class_name Kniving
extends Node2D

func _on_Kniving_body_entered(body):
	if body is Character:
		body.Kniving = true
		body.show = 100
		queue_free()
