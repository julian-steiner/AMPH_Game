class_name FlyingCharakter
extends Node2D

const upflight_max = 200;
const upflight_acc = 80;
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
	
	if Input.is_action_just_pressed("NumPad8"):
		pass
