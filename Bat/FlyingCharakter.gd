class_name FlyingCharakter

extends RigidBody2D

const upflight_max = 200;
const downflight_max = -100;
const xflight_max = 300;
const xflight_acc = 120;

var hp = 100;
var counter = 0;
var step = 0;
var priority = false;
var attak = false;
var attacking = false;
var headnut_copy = 0;
var direction = -1;

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	var key_pressed = false;
	step = state.get_step()
	var on_floor = false;
	
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2(0,-1)) > 0.5:
			on_floor = true
	
	if Input.is_action_just_pressed("ui_KP 8"):
		velocity.y -= upflight_max
		
	if Input.is_action_just_pressed("ui_KP 5"):
		velocity.y -= downflight_max
	
	if Input.is_action_just_pressed("ui_KP 4"):
		velocity.x = min(velocity.x - xflight_acc*step, -xflight_max)
		key_pressed = true
#
	if Input.is_action_just_pressed("ui_KP 6"):
		velocity.x = max(velocity.x + xflight_acc*step, xflight_max)
		key_pressed = true
	
	if Input.is_action_just_pressed("ui_KP enter"):
		attak = true
	
	direction = sign(velocity.x)
	
	if on_floor and not key_pressed: 
		var speed = abs(velocity.x)
		speed = max(speed - xflight_acc * step, 0)
		velocity.x = speed * direction
	
	velocity += state.get_total_gravity() * step
	state.set_linear_velocity(velocity)
	_animation_handling(velocity, on_floor)

func _animation_handling(velocity, on_floor):
	if hp <= 0:
		$AnimatedSprite.play("Death")
		counter += step
		if counter >= 0.5:
			queue_free()
			counter = 0
	elif priority == true:
		$AnimatedSprite.play("Hurt")
		$HealthBar.value = hp
		counter += step
		if counter >= 0.5:
			counter = 0
			priority = false

	elif attak == true:
		init_attack()
		$AnimatedSprite.play("Attak")
		attacking = true;
		counter += step
		if counter >= 0.5:
			print("attak")
			end_attack()
			attak = false
			counter = 0
	
	else:
		if velocity.x != 0:
			if velocity.x > 0:
				$AnimatedSprite.flip_h = false
				direction = 1
			else:
				$AnimatedSprite.flip_h = true
				direction = -1
		
		if Input.is_action_just_pressed("ui_KP enter"):
			$AnimatedSprite.play("Attak")
			attacking = true;
			counter += step
			if counter >= 0.5:
				counter = 0
		
		else:
			if not on_floor:
				$AnimatedSprite.play("Fly")
				print("fly")

			else:
				$AnimatedSprite.play("Idle")
				print("idle")

func init_attack():
	if attacking == false:
		attacking = true
		headnut_copy = load('res://Bat//Headnut.tscn').instance()
		headnut_copy.transform[2].x = 45 * direction
		add_child(headnut_copy)

func end_attack():
	if attacking == true:
		attacking = false;
		headnut_copy.queue_free()
