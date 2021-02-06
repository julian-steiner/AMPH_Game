class_name Tuere_1
extends Node2D

func _on_Tuere_1_body_entered(body):
	if body is Character:
		body.Tuere_1 = true
		body.show = 150
		queue_free()
