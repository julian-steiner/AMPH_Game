class_name FlyingCharakter

extends RigidBody2D

const upflight_max = 200;
#const upflight_acc = 80;
const xflight_max = 200;
const xflight_acc = 80;

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	var step = state.get_step()
	var on_floor = false
	
	for i in range(state.get_contact_count()):
		var contact_normal = state.get_contact_local(i)
		if contact_normal.dot(Vector2(0,-1)) > 0.5:
			on_floor = true
	
	if Input.is_action_just_pressed("ui_KP 8"):
		velocity.y -= upflight_max
	
	if Input.is_action_just_pressed("ui_KP 4") and velocity.y != 0:
		velocity.x = min(velocity.x - xflight_acc*step, -xflight_max)
	if Input.is_action_pressed("ui_KP 4") and velocity.y == 0:
		velocity.x = min(velocity.x - xflight_acc*step, -xflight_max)
	
	if Input.is_action_just_pressed("ui_KP 6") and velocity.y != 0:
		velocity.x = max(velocity.x + xflight_acc*step, xflight_max)
	elif Input.is_action_pressed("ui_KP 6") and velocity.y == 0:
		velocity.x = max(velocity.x + xflight_acc*step, xflight_max)
	
	if Input.is_action_just_pressed("ui_KP enter"):
		$AnimatedSprite.play("Attak")
	
	
	if velocity.y != 0:
		$AnimatedSprite.play("Fly")
	else:
		$AnimatedSprite.play("Idle")
	
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	velocity += state.get_total_gravity() * step
	state.set_linear_velocity(velocity)
