extends Node2D

@onready var InteractionArea = $InteractionArea
@onready var Transition

@export var PathToNextScene: = ""
@export var TeleportLocation : Node2D
@export var DoorTexture : Texture
@export var ShowSprite: = true
@export var SideDoor: = false
@export var Locked: = false

func _ready():
	InteractionArea.Interact = Callable(self, "OnInteract")
	$Sprite2D.visible = ShowSprite
	if SideDoor:
		$InteractionArea/CollisionShape2D.rotate(90)
	if DoorTexture != null:
		$Sprite2D.texture = DoorTexture

func OnInteract():
	Transition = get_tree().get_first_node_in_group("Transition")
	if !PathToNextScene == "" and !Locked:
		Transition.StartTransition()
		$TransitionTimer.start()
	elif !Locked:
		Transition.StartTransition()
		$TeleportTimer.start()
	else:
		# TODO Play locked door sound effect
		$AudioStreamPlayer2D.play()

func _on_timer_timeout():
	get_tree().change_scene_to_file(PathToNextScene)

func _on_teleport_timer_timeout():
	Global.Player.global_position = TeleportLocation.global_position
	Transition.EndTransition()
