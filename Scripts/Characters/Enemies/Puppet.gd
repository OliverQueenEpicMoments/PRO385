extends CharacterBody2D

@export var Damage: = 10

var Rooted: = false
const Speed: = 135.0
var Stuns: = 0

func _physics_process(delta):
	if Stuns > 0:
		Rooted = true
		Damage = 0
	else:
		Rooted = false
		Damage = 10
		
	if (is_instance_valid(Global.Player) and not Rooted):
		var direction = (Global.Player.global_position - global_position).normalized()
		velocity = direction * Speed
	else:
		Global.GetPlayer()
	
	if not Rooted:
		move_and_slide()

func _on_hitbox_stunned():
	# TODO Make sure the animation stops here
	$AnimationPlayer.stop(false)
	Stuns += 1

func _on_hitbox_unstunned():
	Stuns -= 1
	# TODO Make sure the animation continues here
	$AnimationPlayer.play()

func GetDamage():
	Global.CauseOfDeath = "Puppet"
	return Damage
