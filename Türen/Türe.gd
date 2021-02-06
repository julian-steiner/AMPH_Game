class_name Tuere
extends StaticBody2D

const locations = {"Door1": Vector2(-928.004, 1791.935), "Tuere": Vector2(-1190.284, 1471.843), "Tuere2": Vector2(-1369.94, 319.83), "Tuere3": Vector2(-1689.82, -256.035), "Tuere4": Vector2(117.753, 535.582), "Tuere5": Vector2(117.753, 535.582), "Tuere6": Vector2(117.753, 535.582), "TutorialDoor": Vector2(224, 576)};
#{Door1 zu Tuere3, Tuere zu Tuere2, Tuere2 zu Tuere, Tuere3 zu Door1, Tuere4 & Tuere5 & Tuere6 zu start}

var body_current = 0;
var teleporting = false;
var timer = 0;

func _on_Area2D_body_entered(body):
	z_index = -1;
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
	if self.name == "endDoor":
		get_tree().change_scene("res://Levels//Character_Levels//Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
	elif self.name == "endBatDoor":
		get_tree().change_scene("res://Levels//Flying_Levels//Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
	elif self.name == "endTutorialDoor":
		get_tree().change_scene("res://Tutorial//Character//Tutorial_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
	elif self.name == "falseDoor":
		pass
	else:
		body_current.teleport(locations.get(self.name))
		$AnimatedSprite.play("DoorClosed")
		teleporting = false
		timer = 0

func _physics_process(delta):
	if teleporting:
		timer += delta
		if timer >= 0.5:
			execute_teleport();
