class_name knife_flying
extends RigidBody2D

var on_floor = false;

func _on_knife_collision_body_entered(body):
	print(on_floor);
	if body is Enemy and not on_floor:
		body.hp -= 100;
	if not body is Character and not body == self:
		on_floor = true;
	if body is Character and on_floor:
		body.knives += 1;
		queue_free()
