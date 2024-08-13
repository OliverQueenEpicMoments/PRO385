extends Node2D

@onready var InteractionArea = $InteractionArea
@onready var ItemSprite = $Sprite2D

@export var ItemTexture : Texture
@export var GameFlag: = ""

func _ready():
	InteractionArea.Interact = Callable(self, "OnInteract")
	ItemSprite.texture = ItemTexture

func OnInteract():
	match GameFlag:
		"Basement Key":
			GameFlags.FirstHouseKey = true
			print("Basement Key - ", GameFlags.FirstHouseKey)
		"Gas Station Key":
			GameFlags.GasStationeKey = false
			print("Gas Station Key - ", GameFlags.GasStationeKey)
		"Red Key":
			GameFlags.RedKey = false
			print("Red Key - ", GameFlags.RedKey)
			
	queue_free()
