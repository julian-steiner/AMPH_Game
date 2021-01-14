class_name Tuere
extends StaticBody2D

var x = 300
var y = 0

func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body.teleport(Vector2(x, y))
