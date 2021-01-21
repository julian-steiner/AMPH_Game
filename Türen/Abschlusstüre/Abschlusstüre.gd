class_name abschlusstuere
extends StaticBody2D

var body_current = 0;
var teleporting = false;
var timer = 0;

func _on_Area2D_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body_current = body
		init_teleport()

func init_teleport():
	$AnimatedSprite.play("DoorOpen")
	teleporting = true

func execute_teleport():
	get_tree().change_scene("res://Levels//Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")

func _physics_process(delta):
	if teleporting:
		timer += delta
		if timer >= 0.5:
			execute_teleport();
