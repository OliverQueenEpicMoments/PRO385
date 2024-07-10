extends CharacterBody2D

@onready var InteractionArea = $InteractionArea


func _ready():
	InteractionArea.Interact = Callable(self, "OnInteract")

func _physics_process(delta):
	pass

func OnInteract():
	Dialogic.start("Prototype")
