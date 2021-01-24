class_name SpinningTrap
extends StaticBody2D

const Traps = {"SpinningTrap": [false, [[0, 10], [0, 0]]], "SpinningTrap2": [true, [[0, 0], [0, 10]]]};

var give_damage = false;
var counter = 0;
var step = 0;
var body_in = false
var rotate_direction = 0;

var make_variabels = true;
var x_pos_min = 0;
var x_pos_max = 0;
var y_pos_min = 0;
var y_pos_max = 0;

func _physics_process(delta):
	#Direktionen definieren
	var direction = Traps.get(self.name)[0];
	if direction:
		rotate_direction = -1;
	else:
		rotate_direction = 1;

	if make_variabels:
		x_pos_min = Traps.get(self.name)[1][0][0]
		x_pos_max = Traps.get(self.name)[1][0][1]
		y_pos_min = Traps.get(self.name)[1][1][0]
		y_pos_max = Traps.get(self.name)[1][1][1]
		make_variabels = false
	
	#Handling of the Spinning Trap
	step = delta
	$Sprite.flip_h = direction
	$Sprite.rotate(6*delta*rotate_direction)

	damaging()
	movment(x_pos_min, x_pos_max, y_pos_min, y_pos_max)

func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter or body is Enemy:
		give_damage = true;
		body_in = body;
		counter = 0.25;

func _on_Area2D_body_exited(body):
	if body is Character or body is FlyingCharakter or body is Enemy:
		give_damage = false;

func damaging():
	if give_damage == true:
		counter += step
		if counter >= 0.25:
			body_in.hp -= 25
			counter = 0

func movment(x_pos_min, x_pos_max, y_pos_min, y_pos_max):
	if x_pos_max > 0:
		self.transform[2].x += 1
		x_pos_max -= 1
		x_pos_min += 1

	elif x_pos_min > 0: 
		self.transform[2].x -= 1
		x_pos_max += 1
		x_pos_min -= 1

	if y_pos_max > 0:
		self.transform[2].y += 1
		y_pos_max -= 1
		y_pos_min += 1

	elif y_pos_min > 0: 
		self.transform[2].y -= 1
		y_pos_max += 1
		y_pos_min -= 1
	
	
