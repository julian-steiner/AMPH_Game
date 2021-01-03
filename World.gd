class_name main
extends Node2D



func _on_Area2D_body_entered(body):
	if body is Character:
		get_tree().change_scene(("res://Level_1.tscn"))
