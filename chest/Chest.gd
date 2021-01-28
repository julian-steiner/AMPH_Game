class_name chest
extends StaticBody2D

var firsttime_enterd = true;

func _on_Area2D_body_entered(body):
	if body is Character:
		$AnimatedSprite.play("open")
		$AnimatedSprite.transform[2].y -= 6.5
		if firsttime_enterd:
			body.knives += 1;
			firsttime_enterd = false;
			print(body.knives)

func _on_Area2D_body_exited(body):
	if body is Character:
		$AnimatedSprite.play("closed")
		$AnimatedSprite.transform[2].y += 6.5
