extends Area2D

func _on_HitBox_body_entered(body):
	if body is Enemy:
		body.hp -= 20
		if body.name == "KeyEnemy" and body.hp <= 0:
			get_parent().key += 1
			
