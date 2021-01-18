class_name Tuere
extends StaticBody2D

const locations = {"Door1": Vector2(-928.004, 1791.935), "Tuere": Vector2(-1190.284, 1471.843), "Tuere2": Vector2(-1369.94, 319.83)};

var body_current = 0;
var teleporting = false;
var timer = 0;

func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body_current = body
		init_teleport()
		
func _on_Area2D_body_exited(body):
	if body is Character or body is FlyingCharakter:
		body_current = 0
		cancel_teleport()

func init_teleport():
	$AnimatedSprite.play("DoorOpen")
	teleporting = true
	
func cancel_teleport():
	$AnimatedSprite.play("DoorClosed")
	teleporting = false
	timer = 0
	
func execute_teleport():
	body_current.teleport(locations.get(self.name))
	$AnimatedSprite.play("DoorClosed")
	teleporting = false
	timer = 0

func _physics_process(delta):
	if teleporting:
		timer += delta
		if timer >= 0.5:
			execute_teleport();
