extends Node2D

var arrow = 0;

func _on_Area2D_body_entered(body):
	if body is FlyingCharakter:
		arrow = load('res://Enemy//Anti_underschluepfer_Pfeile.tscn').instance();
		add_child(arrow);
	
	if body is Character:
		arrow = load('res://Enemy//Anti_underschluepfer_Pfeile.tscn').instance();
		add_child(arrow);
	
	if body is Enemy:
		arrow = load('res://Enemy//Anti_underschluepfer_Pfeile.tscn').instance();
		add_child(arrow);

func _on_Area2D_body_exited(body):
	if body is FlyingCharakter:
		arrow.queue_free()
	
	if body is Character:
		arrow.queue_free()
	
#	if body is Enemy:
#		arrow.queue_free()
