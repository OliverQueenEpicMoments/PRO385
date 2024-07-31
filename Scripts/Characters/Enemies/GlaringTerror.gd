extends Node2D

@onready var InteractionArea = $InteractionArea

@export var ActivatedTexture : Texture
@export var DeactivatedTexture : Texture
@export var Insanity: = 2.0

var Flip: = [true, false]

# Called when the node enters the scene tree for the first time.
func _ready():
	var Flipping = Flip.pick_random()
	InteractionArea.Interact = Callable(self, "OnInteract")
	$EyeSprite.flip_h = Flipping
	$BackgroundSprite.flip_h = Flipping

func _process(delta):
	if (is_instance_valid(Global.Player)):
		$Lights.look_at(Global.Player.position)
		$Collision/DeathRay/CollisionPolygon2D.look_at(Global.Player.position)
		$PupilOffset.look_at(Global.Player.position)

func OnInteract():
	# TODO play death sound
	queue_free()

func _on_death_ray_body_entered(body):
	#print("Eye hit - ", body)
	$EyeSprite.texture = ActivatedTexture
	$Lights.visible = true
	$Timer.start()

func _on_death_ray_body_exited(body):
	$EyeSprite.texture = DeactivatedTexture
	$Lights.visible = false
	$Timer.stop()

func _on_timer_timeout():
	Global.Player.EyeInsanity(Insanity)
