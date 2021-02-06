class_name Tuere_2
extends Node2D

func _on_Tuere_2_body_entered(body):
	if body is Character:
		body.Tuere_2 = true
		body.show = 150
		queue_free()
