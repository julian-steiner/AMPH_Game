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

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	step = state.get_step()
	var on_floor = false
	
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local(i)
		if contact_normal.dot(Vector2(0,-1)) > 0.5:
			on_floor = true
	
	if Input.is_action_just_pressed("ui_KP 8"):
		velocity.y -= upflight_max
		
	if Input.is_action_just_pressed("ui_KP 5"):
		velocity.y -= downflight_max
	
	if Input.is_action_just_pressed("ui_KP 4"):
		velocity.x = min(velocity.x - xflight_acc*step, -xflight_max)
#
	if Input.is_action_just_pressed("ui_KP 6"):
		velocity.x = max(velocity.x + xflight_acc*step, xflight_max)
	
	velocity += state.get_total_gravity() * step
	state.set_linear_velocity(velocity)
	_animation_handling(velocity)

func _animation_handling(velocity):
	if hp <= 0:
		$AnimatedSprite.play("Death")
		counter += step
		if counter >= 0.5:
			queue_free()
			counter = 0
	elif priority == true:
		$AnimatedSprite.play("Hurt")
		counter += step
		if counter >= 0.5:
			counter = 0
			priority = false
	else:
		if velocity.x != 0:
			if velocity.x > 0:
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.flip_h = true
		
		if Input.is_action_pressed("ui_KP enter"):
			$AnimatedSprite.play("Attak")
			counter += step
			if counter >= 0.5:
				counter = 0
		
		else:
			if velocity.y != 0:
				$AnimatedSprite.play("Fly")

			else:
				$AnimatedSprite.play("Idle")

func _on_Area2D_body_entered(body):
	if body is Character:
		hp -= 10
		print("Hurt")
		priority = true
