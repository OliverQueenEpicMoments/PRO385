extends CharacterBody2D

const SPEED: = 50.0

func _physics_process(delta):
	# Calculate the direction towards the player
	if (is_instance_valid(Global.Player)):
		var direction = (Global.Player.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		Global.GetPlayer()

	# Use move_and_slide for smooth movement and collision response
	move_and_slide()

func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.stop()
	$AnimationPlayer.stop()
	velocity = Vector2()
	print(body)

func _on_area_2d_body_exited(body):
	#$AnimatedSprite2D.play()
	pass
