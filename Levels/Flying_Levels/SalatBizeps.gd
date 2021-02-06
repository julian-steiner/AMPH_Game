class_name SalatBizeps
extends Node2D

func _on_SalatBizeps_body_entered(body):
	if body is FlyingCharakter:
		body.show = 100
		body.SalatBizeps = true;
