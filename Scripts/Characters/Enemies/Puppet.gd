extends CharacterBody2D

var Rooted: = false
const SPEED: = 140.0
var Stuns: = 0

func _physics_process(delta):
	if Stuns > 0:
		Rooted = true
	else:
		Rooted = false
	
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
	Stuns += 1

func _on_hitbox_unstunned():
	Stuns -= 1
	#$AnimatedSprite2D.play()
