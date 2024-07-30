extends Node2D

@onready var InteractionArea = $InteractionArea

@export var ActivatedTexture : Texture
@export var DeactivatedTexture : Texture
@export var Insanity: = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	InteractionArea.Interact = Callable(self, "OnInteract")

func _process(delta):
	$Lights.look_at(Global.Player.position)
	$Collision/DeathRay/CollisionPolygon2D.look_at(Global.Player.position)

func OnInteract():
	# TODO play death sound
	queue_free()

func _on_death_ray_body_entered(body):
	$Sprite2D.texture = ActivatedTexture
	$Lights.visible = true
	$Timer.start()

func _on_death_ray_body_exited(body):
	$Sprite2D.texture = DeactivatedTexture
	$Lights.visible = false
	$Timer.stop()

func _on_timer_timeout():
	Global.Player.EyeInsanity(2)
