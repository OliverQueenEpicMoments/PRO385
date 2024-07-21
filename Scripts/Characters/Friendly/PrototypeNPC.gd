extends CharacterBody2D

@onready var timer = $Timer
@onready var InteractionArea = $InteractionArea
var IsTalking = false

func _ready():
	Dialogic.signal_event.connect(DialogueDone)
	InteractionArea.Interact = Callable(self, "OnInteract")

func DialogueDone(argument: String):
	if (argument == "DialogueOver"):
		# TODO Set off signal or function here to resume player movement by unrooting the player
		timer.start()

func OnInteract():
	if (!IsTalking):
		Dialogic.start("Prototype")
		# TODO Set off signal or function here to root the player in place for the duration of the dialogue
		IsTalking = true

func _on_timer_timeout():
	IsTalking = false 
