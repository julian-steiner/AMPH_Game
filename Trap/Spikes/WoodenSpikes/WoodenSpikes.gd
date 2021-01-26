extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Damage_Area_body_entered(body):
	if body is Character or body is FlyingCharakter:
		body.hp -= 100
	if body is Enemy:
		body.hp -= 40

