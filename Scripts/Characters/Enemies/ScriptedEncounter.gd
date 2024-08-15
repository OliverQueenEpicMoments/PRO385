extends Node2D

@export var ScriptedEnemyType: = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match ScriptedEnemyType:
		"Puppet":
			if GameFlags.FirstHouseKey == true:
				queue_free()
		"Shadowstalker":
			GameFlags.GasStationeKey = false
			print("Cue Shadowstalker scripted cutscene")
		"Blind Enemy":
			print("Cue unnamed blind enemy scripted cutscene")
