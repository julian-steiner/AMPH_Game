class_name Character
extends RigidBody2D

var on_floor = false;
const max_velocity = 100;
const acceleration = 5;
const jump_speed = 100;
var animation_priority = 0;

func handle_animations(var velocity, var priority):
	if abs(velocity.x) > 0:
		$AnimatedSprite.play("WALK")
		if sign(velocity.x) == 1:
			$AnimatedSprite.flip_h = false;
			$AnimatedSprite.offset.x = 20;
		else:
			$AnimatedSprite.flip_h = true;
			$AnimatedSprite.offset.x = -20;

func _integrate_forces(state):
	var velocity = state.get_linear_velocity();
	var key_pressed = false;
	on_floor = false;
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2(0, -1)) > 0.5:
			on_floor = true
	print(on_floor)
	if(on_floor):
		if(Input.is_action_pressed("ui_left")):
			velocity.x = max(velocity.x - acceleration, -max_velocity);
			key_pressed = true;
		if(Input.is_action_pressed(("ui_right"))):
			velocity.x = min(velocity.x + acceleration, max_velocity);
			key_pressed = true;
		if(Input.is_action_pressed(("ui_up"))):
			velocity.y = -jump_speed
			key_pressed = true;
		if(not key_pressed):
			var speed = abs(velocity.x);
			var direction = sign(velocity.x)
			speed = max(speed - acceleration, 0)
			velocity.x = speed * direction;
	
	handle_animations(velocity, 0)

	
	state.linear_velocity = velocity;
