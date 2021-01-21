class_name Dagger
extends Area2D

func _on_Hitbox_body_entered(body):
	if body is Enemy:
		body.hp -= 20
