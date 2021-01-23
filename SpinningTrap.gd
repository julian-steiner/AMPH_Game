class_name SpinningTrap
extends StaticBody2D

func _physics_process(delta):
	$Sprite.rotate(4.5*delta)



func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body.hp -= 25
