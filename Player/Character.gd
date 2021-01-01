class_name Character
extends RigidBody2D

var on_floor = false;
var direction = 0;
const walk_velocity = 100;
const sprint_velocity = 150;
const acceleration = 130;
const jump_speed = 200;

var animation_priority = 0;
var on_floor_previous = false;
var animation_counter = 0;
var step = 0;
var c_position = 0;
	
var hp = 100;
var hp_p = 100; #Variable to store the previous hp

var cooldown = 0;
var cooldown2 = 0;
var dagger_copy = 0;
var attacking = false;

func handle_animations(var velocity, var priority):
	#priorities: 1 = JUMP_BEGIN, 2 = JUMP_END, 3 = ATTACK_STANDING, 4 = ATTACK_MOVING, 5 = HURT, 6 = DEATH, 7 = IN_AIR, 8 = THROW
	#CHANGE THE ORIENTATION OF THE CHARACTER ACCORDING TO THE DIRECTION IT'S MOVING
	if sign(velocity.x) != 0:
		if sign(velocity.x) == 1:
			$AnimatedSprite.flip_h = false;
			$AnimatedSprite.offset.x = 20;
			direction = 1;
		else:
			$AnimatedSprite.flip_h = true;
			$AnimatedSprite.offset.x = -20;
			direction = -1;
		
	if hp <= 0:
		$AnimatedSprite.offset.y = -10;
		$AnimatedSprite.play("DEATH");
		animation_priority = 5;
		
	if hp < hp_p:
		$AnimatedSprite.play("HURT");
		animation_priority = 4;
				
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
			if (animation_counter == step):
				init_attack()
			elif (animation_counter >= 1):
				animation_priority = 0;
				animation_counter = 0;
				end_attack()
		elif abs(velocity.x) != 0 and abs(velocity.x) <= walk_velocity:
			$AnimatedSprite.play("ATTACK_MOVING");
			animation_counter += step;
			if (animation_counter == step):
				init_attack()
			elif (animation_counter >= 1):
				animation_priority = 0;
				animation_counter = 0;
				end_attack()
		elif abs(velocity.x) > walk_velocity:
			$AnimatedSprite.play("ATTACK_SPRINTING");
			animation_counter += step;
			if (animation_counter == step):
				init_attack()
			elif (animation_counter >= 1):
				animation_priority = 0;
				animation_counter = 0;
				end_attack()
	
	elif (animation_priority == 8):
		$AnimatedSprite.play("THROW");
		animation_counter += step;
		if (animation_counter >= 0.4):
			animation_priority = 0;
			animation_counter = 0;
			throw_knife();
	
	#wait for the hurt animation to be finished
	elif (animation_priority == 4):
		animation_counter += step;
		if (animation_counter >= 0.4):
			animation_priority = 0;
			animation_counter = 0;
	
	elif (animation_priority == 5):
		animation_counter += step;
		if (animation_counter >= 1):
			queue_free();
			print("Deleted")
	
	elif (animation_priority == 6):
		$AnimatedSprite.play("IN_AIR");
		
	else:
		if abs(velocity.x) > 0 and abs(velocity.x) <= walk_velocity:
			$AnimatedSprite.play("WALK");
		elif abs(velocity.x) > walk_velocity:
			$AnimatedSprite.play("SPRINT");
		else:
			$AnimatedSprite.play("IDLE");
			
	hp_p = hp;

func init_attack():
	if attacking == false:
		attacking = true
		dagger_copy = load('res://Player//Dagger.tscn').instance()
		dagger_copy.transform[2].x = 45 * direction
		add_child(dagger_copy)

func end_attack():
	if attacking == true:
		attacking = false;
		dagger_copy.queue_free()
		
func throw_knife():
	var knife = load('res://Player//Knife.tscn').instance();
	knife.transform[2].y = -30
	knife.transform[2].x = 40 * direction
	knife.angular_velocity = 5 * direction
	knife.linear_velocity.x = 300 * direction
	knife.linear_velocity.y = -200
	
	print(knife.angular_velocity)
	add_child(knife);
	
func _integrate_forces(state):
	step = state.get_step();
	c_position = state.transform[2];
	var velocity = state.get_linear_velocity();
	var key_pressed = false;
	on_floor = false;
	$HealthBar.value = hp;

	cooldown = max(cooldown - step, 0);
	cooldown2 = max(cooldown2 - step, 0);
	
	#check if the player touches the ground
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2(0, -1)) > 0.5:
			on_floor = true
	
	#check if the player just hit the ground
	if(on_floor == true and on_floor_previous == false):
		#set the animationPriority to jump_end
		animation_priority = 2;
	on_floor_previous = on_floor;
	
	if(on_floor):
		if(Input.is_mouse_button_pressed(1) and cooldown == 0 and animation_priority != 4 and animation_priority != 8):
			#set the animation_priority to attack
			animation_priority = 3;
			cooldown = 1;
			
		if(Input.is_mouse_button_pressed(2) and cooldown2 == 0 and animation_priority != 4 and animation_priority != 3):
			animation_priority = 8;
			cooldown2 = 1;
		
		#basic movements
		if(Input.is_action_pressed("ui_left")):
			velocity.x = max(velocity.x - acceleration * step, -sprint_velocity);
			key_pressed = true;
		if(Input.is_action_pressed("ui_right")):
			velocity.x = min(velocity.x + acceleration * step, sprint_velocity);
			key_pressed = true;
		if(Input.is_action_just_pressed("ui_up")):
			velocity.y = -jump_speed
			key_pressed = true;
			# set the animation priority to jump_begin
			animation_priority = 1;
		
		if(not key_pressed):
			var speed = abs(velocity.x);
			var direction = sign(velocity.x)
			speed = max(speed - acceleration * step, 0)
			velocity.x = speed * direction;
	else:
		if (animation_priority == 0):
			animation_priority = 6
	
	handle_animations(velocity, 0);
	
	state.linear_velocity = velocity;
