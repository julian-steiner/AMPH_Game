class_name Enemy
extends RigidBody2D

var on_floor = false;
const walk_velocity = 80;
const sprint_velocity = 130;
const acceleration = 130;
const deadZone = 100;
const attackZone = 200;

var animation_priority = 0;
var on_floor_previous = false;
var animation_counter = 0;
var step = 0;
var c_position = 0;

var playerInRange = false;
var playerCopy = 0;

var hp = 100;
var hp_p = 100; #Variable to store the previous hp

var cooldown = 0;

func handle_animations(var velocity, var priority):
	#priorities: 1 = JUMP_BEGIN, 2 = JUMP_END, 3 = ATTACK_STANDING, 4 = ATTACK_MOVING, 5 = HURT, 6 = DEATH, 7 = IN_AIR
	#CHANGE THE ORIENTATION OF THE CHARACTER ACCORDING TO THE DIRECTION IT'S MOVING
	if sign(velocity.x) != 0:
		if sign(velocity.x) == 1:
			$AnimatedSprite.flip_h = false;
			$AnimatedSprite.offset.x = 20;
		else:
			$AnimatedSprite.flip_h = true;
			$AnimatedSprite.offset.x = -20;
		
	if hp <= 0:
		$AnimatedSprite.offset.y = 15;
		$AnimatedSprite.play("DEATH");
		animation_priority = 5;
		
	if hp < hp_p:
		$AnimatedSprite.play("HURT");
		animation_priority = 4;
				
	elif (animation_priority == 3):
		$AnimatedSprite.play("ATTACK_STANDING");
		animation_counter += step;
		if (animation_counter >= 1):
			animation_priority = 0;
			animation_counter = 0;
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
		
	else:
		if abs(velocity.x) > 0 and abs(velocity.x) <= walk_velocity:
			$AnimatedSprite.play("WALK");
		elif abs(velocity.x) > walk_velocity:
			$AnimatedSprite.play("SPRINT");
		else:
			$AnimatedSprite.play("IDLE");
	
	hp_p = hp;

func _integrate_forces(state):
	step = state.get_step();
	c_position = state.transform[2];
	var velocity = state.get_linear_velocity();
	var key_pressed = false;
	on_floor = false;
	
	cooldown = max(cooldown - step, 0);
	
	#check if the player touches the ground
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2(0, -1)) > 0.5:
			on_floor = true
	
	#controls
	if(on_floor):
		if(playerInRange):
			#calculate the postiiondifference
			var positionDifference = pow(pow(abs(playerCopy.c_position.x - c_position.x), 2) + pow(abs(playerCopy.c_position.y - c_position.y), 2), 0.5);
			if(positionDifference >= deadZone):
				velocity.x = min(velocity.x + (acceleration * step), sprint_velocity);
			elif(positionDifference <= -deadZone):
				velocity.x = max(velocity.x - (acceleration * step), -sprint_velocity);
			if(abs(positionDifference) < deadZone):
				var speedX = abs(velocity.x)
				var direction = sign(velocity.x)
				velocity.x = max(speedX - (acceleration * 2) * step, 0) * direction;
			print(positionDifference)
			if(positionDifference <= attackZone and cooldown == 0):
				animation_priority = 3;
				cooldown = 3;
				print("ATTACKING")
			
	handle_animations(velocity, 0);
	
	cooldown = max(0, cooldown - step)
	
	state.linear_velocity = velocity;

func _on_Area2D_body_entered(body):
	if body is Character:
		playerInRange = true;
		playerCopy = body;
		
func _on_Area2D_body_exited(body):
	if body is Character:
		playerInRange = false;
		playerCopy = 0;
