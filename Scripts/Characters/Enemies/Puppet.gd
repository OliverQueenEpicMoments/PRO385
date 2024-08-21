extends CharacterBody2D

@onready var AnimTree: AnimationTree = $AnimationTree

@export var Damage: = 10
var Direction : Vector2

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
		Direction = (Global.Player.global_position - global_position).normalized()
		velocity = Direction * Speed
		UpdateAnimations()
	else:
		Direction = (Global.Player.global_position - global_position).normalized()
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

func UpdateAnimations():
	var CorrectedDirection = Direction
	CorrectedDirection.y = -CorrectedDirection.y
	#print("Direction vector - ", CorrectedDirection)
	
	AnimTree["parameters/InjuredWalk2/blend_position"] = CorrectedDirection
	AnimTree["parameters/InjuredWalk/blend_position"] = CorrectedDirection
