extends CharacterBody2D

@export var Damage: = 100

const SPEED: = 50.0

func _physics_process(delta):
	# Calculate the direction towards the player
	if (is_instance_valid(Global.Player)):
		var direction = (Global.Player.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		Global.GetPlayer()

	move_and_slide()

func GetDamage():
	Global.CauseOfDeath = "Insanity"
	return Damage
