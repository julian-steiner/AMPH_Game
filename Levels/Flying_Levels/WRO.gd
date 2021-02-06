class_name WRO
extends Node2D

func _on_WRO_body_entered(body):
	if body is FlyingCharakter:
		body.show = 100
		body.WRO = true;
