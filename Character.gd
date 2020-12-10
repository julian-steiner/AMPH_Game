class_name Character
extends RigidBody2D

var on_floor = false;
const walk_velocity = 100;
const sprint_velocity = 150;
const acceleration = 80;
const jump_speed = 100;

var animation_priority = 0;
var on_floor_previous = false;
var animation_counter = 0;

var cooldown = 0;

func handle_animations(var velocity, var priority, step):
	#CHANGE THE ORIENTATION OF THE CHARACTER ACCORDING TO THE DIRECTION IT'S MOVING
	if sign(velocity.x) == 1:
		$AnimatedSprite.flip_h = false;
		$AnimatedSprite.offset.x = 20;
	else:
		$AnimatedSprite.flip_h = true;
		$AnimatedSprite.offset.x = -20;
				
	#PLAY THE JUMP AND IN_AIR ANIMATION IF THE CHARACTER IS JUMPING
	if (animation_priority == 1):
		$AnimatedSprite.play("JUMP_BEGIN");
	#PLAY THE LANDING ANIMATION IF THE CHARACTER IS LANDING
	elif (animation_priority == 2):
		$AnimatedSprite.play("JUMP_END");
		animation_counter += step;
		if (animation_counter >= 0.2):
			animation_priority = 0;
			animation_counter = 0;
	#PLAY ONE OF THE ATTACKING ANIMATION IF THE CHARACTER IS ATTACKING
	elif (animation_priority == 3):
		if abs(velocity.x) == 0:
			$AnimatedSprite.play("ATTACK_STANDING");
			animation_counter += step;
			if (animation_counter >= 1):
				animation_priority = 0;
				animation_counter = 0;
		elif abs(velocity.x) != 0 and abs(velocity.x) <= walk_velocity:
			$AnimatedSprite.play("ATTACK_MOVING");
			animation_counter += step;
			if (animation_counter >= 1):
				animation_priority = 0;
				animation_counter = 0;
		elif abs(velocity.x) > walk_velocity:
			$AnimatedSprite.play("ATTACK_SPRINTING");
			animation_counter += step;
			if (animation_counter >= 1):
				animation_priority = 0;
				animation_counter = 0;
		
	else:
		if abs(velocity.x) > 0 and abs(velocity.x) <= walk_velocity:
			$AnimatedSprite.play("WALK");
		elif abs(velocity.x) > walk_velocity:
			$AnimatedSprite.play("SPRINT");
		else:
			$AnimatedSprite.play("IDLE");

func _integrate_forces(state):
	var step = state.get_step();
	var velocity = state.get_linear_velocity();
	var key_pressed = false;
	on_floor = false;
	
	cooldown = max(cooldown - step, 0);
	
	#check if the player touches the ground
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2(0, -1)) > 0.5:
			on_floor = true
	
	#check if the player just hit the ground
	if(on_floor == true and on_floor_previous == false):
		print("Hit floor");
		#set the animationPriority to jump_end
		animation_priority = 2;
	on_floor_previous = on_floor;
		
	if(on_floor):
		if(Input.is_mouse_button_pressed(1) and cooldown == 0):
			#set the animation_priority to attack
			animation_priority = 3;
			cooldown = 2;
		
		#basic movements
		if(Input.is_action_pressed("ui_left")):
			velocity.x = max(velocity.x - acceleration * step, -sprint_velocity);
			key_pressed = true;
		if(Input.is_action_pressed("ui_right")):
			velocity.x = min(velocity.x + acceleration * step, sprint_velocity);
			key_pressed = true;
		if(Input.is_action_pressed("ui_up")):
			velocity.y = -jump_speed
			key_pressed = true;
			# set the animation priority to jump_begin
			animation_priority = 1;
			
		if(not key_pressed):
			var speed = abs(velocity.x);
			var direction = sign(velocity.x)
			speed = max(speed - acceleration * step, 0)
			velocity.x = speed * direction;
	
	handle_animations(velocity, 0, step);

	
	state.linear_velocity = velocity;
