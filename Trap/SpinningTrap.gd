class_name SpinningTrap
extends StaticBody2D

const Traps = {"SpinningTrap": [false, [[0, 100], [0, 0]]], "SpinningTrap2": [true, [[0, 0], [0, 100]]]};

var give_damage = false;
var counter = 0;
var step = 0;
var body_in = false
var rotate_direction = 0;

func _physics_process(delta):
	#Direktionen definieren
	var direction = Traps.get(self.name)[0];
	if direction:
		rotate_direction = -1;
	else:
		rotate_direction = 1;
	
	#Handling of the Spinning Trap
	step = delta
	$Sprite.flip_h = direction
	$Sprite.rotate(6*delta*rotate_direction)
	for i in range(Traps.get(self.name)[1][0][0], Traps.get(self.name)[1][0][0]):
		pass
	damaging()

func _on_Area2D_body_entered(body):
	give_damage = true;
	body_in = body;
	counter = 0.25;

func _on_Area2D_body_exited(body):
	give_damage = false;

func damaging():
	if give_damage == true:
		counter += step
		if counter >= 0.25:
			body_in.hp -= 25
			counter = 0
