extends Node2D

@export var StopsPuppet: = true

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if StopsPuppet:
		$StaticBody2D/CollisionShape2D.disabled = false
	else:
		$StaticBody2D/CollisionShape2D.disabled = true
