class_name SpinningTrap
extends StaticBody2D

const Traps = {"SpinningTrapT": [true, [0, 0]],"SpinningTrapF": [false, [0, 0]], "SpinningTrap": [false, [-3*64, 0]], "SpinningTrap2": [true, [3*64, 0]], "SpinningTrap3": [false, [6*64, 0]], "SpinningTrap4": [true, [-6*64, 0]], "SpinningTrap5": [false, [0, -3*64]], "SpinningTrap6": [true, [0, 3*64]]};

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
var y_first_round = true;
var x_first_round = true;
var x_y_diffrenz = 1;
var speed_x = 1;
var speed_y = 1;

func _physics_process(delta):
	#Direktionen definieren
	var direction = Traps.get(self.name)[0];
	if direction:
		rotate_direction = -1;
	else:
		rotate_direction = 1;

	if make_variabels:
		x_pos_max = Traps.get(self.name)[1][0]
		y_pos_max = Traps.get(self.name)[1][1]
		speed_x = abs(x_pos_max/(64))
		speed_y = abs(y_pos_max/(64))

		if y_pos_max != 0:
			if x_pos_max != 0:
				x_y_diffrenz = x_pos_max/y_pos_max
		
		if x_pos_max < 0:
			x_first_round = false
			x_pos_min = abs(x_pos_max)
			x_pos_max = 0
		
		if y_pos_max < 0:
			y_first_round = false
			y_pos_min = abs(y_pos_max)
			y_pos_max = 0
		
		make_variabels = false
	
	#Handling of the Spinning Trap
	step = delta
	$Sprite.flip_h = direction
	$Sprite.rotate(6*delta*rotate_direction)

	damaging()
	movment()

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

func movment():
	if x_first_round:
		if x_pos_max > 0:
			self.transform[2].x += 2*speed_x
			x_pos_max -= 2*speed_x
			x_pos_min += 2*speed_x
		
		else:
			x_first_round = false
	
	else:
		if x_pos_min > 0:
			self.transform[2].x -= 2*speed_x
			x_pos_max += 2*speed_x
			x_pos_min -= 2*speed_x
		
		else:
			x_first_round = true
		
	if y_first_round:
		if y_pos_max > 0:
			self.transform[2].y += (2/x_y_diffrenz)*speed_y
			y_pos_max -= (2/x_y_diffrenz)*speed_y
			y_pos_min += (2/x_y_diffrenz)*speed_y

		else:
			y_first_round = false
	
	else:
		if y_pos_min > 0:
			self.transform[2].y -= (2/x_y_diffrenz)*speed_y
			y_pos_max += (2/x_y_diffrenz)*speed_y
			y_pos_min -= (2/x_y_diffrenz)*speed_y

		else:
			y_first_round = true
