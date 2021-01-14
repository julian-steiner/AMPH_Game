class_name Tuere
extends StaticBody2D

const locations = {"Door1": Vector2(300, 0)};

func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body.teleport(locations.get(self.name))

