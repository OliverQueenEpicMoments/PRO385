extends Node2D

@onready var InteractionArea = $InteractionArea
@onready var Transition

@export var PathToNextScene: = ""

func _ready():
	InteractionArea.Interact = Callable(self, "OnInteract")

func OnInteract():
	Transition = get_tree().get_first_node_in_group("Transition")
	Transition.StartTransition()
	$Timer.start()

func _on_timer_timeout():
	get_tree().change_scene_to_file(PathToNextScene)
