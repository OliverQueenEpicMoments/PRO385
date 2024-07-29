extends CharacterBody2D

var Rooted: = false
const SPEED: = 140.0

func _physics_process(delta):
	# Calculate the direction towards the player
	if (is_instance_valid(Global.Player) and not Rooted):
		var direction = (Global.Player.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		Global.GetPlayer()
	
	if not Rooted:
		move_and_slide()

func _on_hitbox_stunned():
	$AnimatedSprite2D.stop()
	$AnimationPlayer.stop()
	Rooted = true

func _on_hitbox_unstunned():
	Rooted = false
	#$AnimatedSprite2D.play()
