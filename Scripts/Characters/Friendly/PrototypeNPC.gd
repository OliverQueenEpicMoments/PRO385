extends CharacterBody2D

@onready var timer = $Timer
@onready var InteractionArea = $InteractionArea
var IsTalking = false

func _ready():
	Dialogic.signal_event.connect(DialogueDone)
	InteractionArea.Interact = Callable(self, "OnInteract")

func _physics_process(delta):
	pass

func DialogueDone(argument: String):
	if (argument == "DialogueOver"):
		timer.start()

func OnInteract():
	if (!IsTalking):
		Dialogic.start("Prototype")
		IsTalking = true

func _on_timer_timeout():
	IsTalking = false 
