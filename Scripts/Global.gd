extends Node

@onready var Player
var PlayerSanity = 0
var MaxInsanity = false

func _ready():
	Player = get_tree().get_first_node_in_group("Player")

func SetSanity(sanity):
	PlayerSanity = sanity
	
	if (PlayerSanity >= 100):
		MaxInsanity = true
	else:
		MaxInsanity = false
