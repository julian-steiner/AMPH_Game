class_name sword
extends Area2D


func _on_Hitbox_body_entered(body):
	if body is Character:
		body.hp -= 10;
