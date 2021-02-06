class_name EulerischeIdentitaet
extends Node2D



func _on_Area2D_body_entered(body):
	if body is Character:
		body.euler = true
		body.euler_show = 100
