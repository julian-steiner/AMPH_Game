extends Node2D

func dynamic_zooming():
	var window_size = OS.window_size
	get_node("FlyingCharakter/Camera2D").zoom = Vector2(1024 / window_size.x  , 600 / window_size.y)

func _ready():
	dynamic_zooming()
