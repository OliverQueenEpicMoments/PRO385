extends Node2D

@onready var MainPlayer = get_tree().get_first_node_in_group("Player")

signal FearPlayer()
signal StopFearing()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# For inflicting insanity to the player
func _on_area_2d_body_entered(body):
	if (body.has_method("Player")):
		FearPlayer.emit()
		#print("Player entered AOE")

func _on_area_2d_body_exited(body):
	if (body.has_method("Player")):
		StopFearing.emit()
		#print("Player exited AOE")

func InflictFear():
	pass
