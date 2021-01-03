class_name knife_flying
extends RigidBody2D

var on_floor = false;

func _integrate_forces(state):
	if on_floor:
		state.linear_velocity = Vector2(0, 0)

func _on_knife_collision_body_entered(body):
	print(on_floor);
	if body is Enemy and not on_floor:
		body.hp -= 100;
	if not body is Character and not body == self:
		on_floor = true;
		
func _on_pickup_collision_body_entered(body):
	if body is Character and on_floor:
		body.knives += 1;
		queue_free()
