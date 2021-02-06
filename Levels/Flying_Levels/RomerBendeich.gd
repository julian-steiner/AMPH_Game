class_name RomerBendeich
extends Node2D

func _on_Romerbendeich_body_entered(body):
	if body is FlyingCharakter:
		body.show = 100
		body.RomerBendeich = true;
