class_name Tuere
extends Area2D

var x = 0
var y = 0

func _on_Tuere_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body.transform[2] = Vector2(x,y)
