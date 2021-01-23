class_name knife_flying
extends RigidBody2D

var on_floor = false;
var velocity = Vector2(0, 0);
var angle = 0;
const m = 1;

func to_degrees(angle):
	return angle / (2 * PI) * 360 + 180

func to_radians(angle):
	return (angle - 180) / 360 * 2 * PI 

func calculate_friction():
	return 0.5 * (0.000678 * sin(0.03605 * angle * (-1.71782)) + 0.00154) * 1.2 * pow(velocity.x, 2) * sign(velocity.x)

func _integrate_forces(state):
	angle = to_degrees(state.get_transform().get_rotation());
	if on_floor:
		state.linear_velocity = Vector2(0, 0)
		state.angular_velocity = 0
		self.set_gravity_scale(1.0);
	else:
#		state.linear_velocity = Vector2(300, state.linear_velocity.y)
#		state.linear_velocity.y -= calculate_friction()
		state.linear_velocity.x = velocity.x - calculate_friction() * state.get_step()

func _on_knife_collision_body_entered(body): 
	if body is Enemy and not on_floor:
		body.hp -= 100;
		self.velocity = Vector2(0, 0);
		self.angular_velocity = 0
	if not body is Character and not body == self and not body is Enemy:
		on_floor = true;

func _on_pickup_collision_body_entered(body):
	if body is Character and on_floor:
		body.knives += 1;
		queue_free()
