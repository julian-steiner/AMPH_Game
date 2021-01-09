class_name knife_flying
extends RigidBody2D

var on_floor = false;

func _integrate_forces(state):
	print(state.angular_velocity)
	if on_floor:
		state.linear_velocity = Vector2(0, 0)
		state.angular_velocity = 0
		self.set_gravity_scale(1.0);

func _on_knife_collision_body_entered(body): 
	print("Collision")
	if body is Enemy and not on_floor:
		body.hp -= 100;
		self.linear_velocity = Vector2(0, 0)
	if not body is Character and not body == self and not body is Enemy:
		on_floor = true;

func _on_pickup_collision_body_entered(body):
	print("Collision")
	if body is Character and on_floor:
		body.knives += 1;
		print("Removed Knife")
		queue_free()
