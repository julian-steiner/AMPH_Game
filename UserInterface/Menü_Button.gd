extends Node2D

func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
#	$Menue_Button/Button_Sound.play();
	get_tree().change_scene("res://UserInterface/UI.tscn")
