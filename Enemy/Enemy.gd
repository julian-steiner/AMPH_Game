class_name Enemy
extends RigidBody2D

var on_floor = false;

const walk_velocity = 80;
const sprint_velocity = 130;
const acceleration = 130;
const deadZone = 100;
const attackZone = 150;

var animation_priority = 0;
var on_floor_previous = false;
var animation_counter = 0;
var step = 0;
var c_position = 0;
var direction = 0;

var playerInRange = false;
var playerCopy = 0;
var sword = 0;
var attacking = false;
var dying = false;

var first_loading = true;

var hp = 40;
var hp_p = 40; #Variable to store the previous hp

var cooldown = 0;

func handle_animations(var velocity, var priority):
	#priorities: 1 = JUMP_BEGIN, 2 = JUMP_END, 3 = ATTACK_STANDING, 4 = ATTACK_MOVING, 5 = DEATH, 6 = x, 7 = IN_AIR
	#CHANGE THE ORIENTATION OF THE CHARACTER ACCORDING TO THE DIRECTION IT'S MOVING
	if sign(velocity.x) != 0:
		if direction == 1:
			$AnimatedSprite.flip_h = false;
			$AnimatedSprite.offset.x = 20;
		else:
			$AnimatedSprite.flip_h = true;
			$AnimatedSprite.offset.x = -20;
		
	if hp <= 0 and not dying:
		print("Death")
		$AnimatedSprite.offset.y = 15;
		$AnimatedSprite.play("DEATH");
		dying = true;
		animation_priority = 5;
		
	if hp < hp_p and not dying:
		animation_counter = 0;
		$Sounds/HurtSound.play();
		$AnimatedSprite.play("HURT");
		animation_priority = 4;
				
	elif (animation_priority == 3):
		$AnimatedSprite.play("ATTACK_STANDING");
		animation_counter += step;
		if (animation_counter >= 1):
			animation_priority = 0;
			animation_counter = 0;
			end_attack();
		elif (animation_counter >= 0.4):
			init_attack();
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
		
	else:
		if abs(velocity.x) > 0 and abs(velocity.x) <= walk_velocity:
			$AnimatedSprite.play("WALK");
		elif abs(velocity.x) > walk_velocity:
			$AnimatedSprite.play("SPRINT");
		else:
			$AnimatedSprite.play("IDLE");
	
	if attacking and animation_priority != 3 and animation_priority != 4:
		print("Attack ended");
		end_attack();
	
	hp_p = hp;
	
func init_attack():
	if(attacking == false):
		attacking = true;
		sword = load("res://Enemy//Sword.tscn").instance()
		sword.transform[2].x = 70 * direction + -1 * direction
		add_child(sword)
	
func end_attack():
	attacking = false;
	sword.queue_free();

func _integrate_forces(state):
	step = state.get_step();
	c_position = state.transform[2];
	var velocity = state.get_linear_velocity();
	var key_pressed = false;
	on_floor = false;
	$Healthbar.value = hp
	
	cooldown = max(cooldown - step, 0);
	
	#check if the player touches the ground
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2(0, -1)) > 0.5:
			on_floor = true
	
	#controls
	if(on_floor and not dying):
		if(playerInRange):
			#calculate the postiiondifference
			var positionDifference = pow(pow(abs(playerCopy.c_position.x - c_position.x), 2) + pow(abs(playerCopy.c_position.y - c_position.y), 2), 0.5);
			positionDifference *= sign(playerCopy.c_position.x - c_position.x)
			if(positionDifference >= deadZone):
				velocity.x = min(velocity.x + (acceleration * step), sprint_velocity);
				direction = 1;
			elif(positionDifference <= -deadZone):
				velocity.x = max(velocity.x - (acceleration * step), -sprint_velocity);
				direction = -1;
			if(abs(positionDifference) < deadZone):
				var speedX = abs(velocity.x)
				var direction = sign(velocity.x)
				velocity.x = max(speedX - (acceleration * 2) * step, 0) * direction;
			if(positionDifference <= attackZone and cooldown == 0 and animation_priority != 4):
				animation_priority = 3;
				cooldown = 4;
	
		else:
			var speedX = abs(velocity.x)
			var direction = sign(velocity.x)
			velocity.x = max(speedX - acceleration * step, 0) * direction;
	
	handle_animations(velocity, 0);
	
	if first_loading:
		add_child(load('res://Enemy//Anti_underschluepfer.tscn').instance());
		first_loading = false
	
	cooldown = max(0, cooldown - step)
	
	if dying:
		velocity = Vector2(0, 0)
	
	state.linear_velocity = velocity;

func _on_Range_body_entered(body):
	if body is Character:
		playerInRange = true;
		playerCopy = body;

	if body is FlyingCharakter:
		playerInRange = true;
		playerCopy = body;

func _on_Range_body_exited(body):
	if body is Character:
		playerInRange = false;
		playerCopy = 0;
	
	if body is FlyingCharakter:
		playerInRange = false;
		playerCopy = 0;
