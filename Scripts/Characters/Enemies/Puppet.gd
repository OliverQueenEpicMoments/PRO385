extends CharacterBody2D

@onready var AnimTree: AnimationTree = $AnimationTree
var CurrentAnimIndex : int
var NextAnimIndex : int

@export var Damage: = 10
var Direction : Vector2

var Rooted: = false
const Speed: = 175.0
var Stuns: = 0

func _ready() -> void:
	GetRandomAnim()
	AnimTree.set("parameters/conditions/InjuredWalk2", true)

func _physics_process(_delta):
	print("Stuns - ", Stuns)
	
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
	AnimTree.active = false
	GetRandomAnim()
	Stuns = clamp(Stuns + 1, 0, 2)

func _on_hitbox_unstunned():
	$Timer.start()
	AnimConditionLogic()
	AnimTree.active = true

func GetDamage():
	Global.CauseOfDeath = "Puppet"
	return Damage

func UpdateAnimations():
	var CorrectedDirection = Direction
	CorrectedDirection.y = -CorrectedDirection.y
	#print("Direction vector - ", CorrectedDirection)
	
	AnimTree["parameters/InjuredWalk/blend_position"] = CorrectedDirection
	AnimTree["parameters/InjuredWalk2/blend_position"] = CorrectedDirection
	AnimTree["parameters/ReachingOut/blend_position"] = CorrectedDirection
	AnimTree["parameters/SadWalk/blend_position"] = CorrectedDirection
	AnimTree["parameters/ScarierWalk/blend_position"] = CorrectedDirection
	AnimTree["parameters/ScaryWalk/blend_position"] = CorrectedDirection

func GetRandomAnim():
	NextAnimIndex = randi() % 6 
	
	while NextAnimIndex == CurrentAnimIndex:
		NextAnimIndex = randi() % 6 
	
	CurrentAnimIndex = NextAnimIndex

func _on_timer_timeout() -> void:
	Stuns = clamp(Stuns - 1, 0, Stuns)
	#Stuns -= 1

func AnimConditionLogic():
	match NextAnimIndex:
		0:
			AnimTree.set("parameters/conditions/InjuredWalk2", true)
			
			AnimTree.set("parameters/conditions/InjuredWalk", false)
			AnimTree.set("parameters/conditions/ReachingOut", false)
			AnimTree.set("parameters/conditions/SadWalk", false)
			AnimTree.set("parameters/conditions/ScarierWalk", false)
			AnimTree.set("parameters/conditions/ScaryWalk", false)
		1:
			AnimTree.set("parameters/conditions/InjuredWalk", true)
			
			AnimTree.set("parameters/conditions/InjuredWalk2", false)
			AnimTree.set("parameters/conditions/ReachingOut", false)
			AnimTree.set("parameters/conditions/SadWalk", false)
			AnimTree.set("parameters/conditions/ScarierWalk", false)
			AnimTree.set("parameters/conditions/ScaryWalk", false)
		2:
			AnimTree.set("parameters/conditions/ReachingOut", true)
			
			AnimTree.set("parameters/conditions/InjuredWalk2", false)
			AnimTree.set("parameters/conditions/InjuredWalk", false)
			AnimTree.set("parameters/conditions/SadWalk", false)
			AnimTree.set("parameters/conditions/ScarierWalk", false)
			AnimTree.set("parameters/conditions/ScaryWalk", false)
		3:
			AnimTree.set("parameters/conditions/SadWalk", true)
			
			AnimTree.set("parameters/conditions/InjuredWalk2", false)
			AnimTree.set("parameters/conditions/InjuredWalk", false)
			AnimTree.set("parameters/conditions/ReachingOut", false)
			AnimTree.set("parameters/conditions/ScarierWalk", false)
			AnimTree.set("parameters/conditions/ScaryWalk", false)
		4:
			AnimTree.set("parameters/conditions/ScarierWalk", true)
			
			AnimTree.set("parameters/conditions/InjuredWalk2", false)
			AnimTree.set("parameters/conditions/InjuredWalk", false)
			AnimTree.set("parameters/conditions/ReachingOut", false)
			AnimTree.set("parameters/conditions/SadWalk", false)
			AnimTree.set("parameters/conditions/ScaryWalk", false)
		5:
			AnimTree.set("parameters/conditions/ScaryWalk", true)
			
			AnimTree.set("parameters/conditions/InjuredWalk2", false)
			AnimTree.set("parameters/conditions/InjuredWalk", false)
			AnimTree.set("parameters/conditions/ReachingOut", false)
			AnimTree.set("parameters/conditions/SadWalk", false)
			AnimTree.set("parameters/conditions/ScarierWalk", false)
		_:
			print("Invalid index: ", NextAnimIndex)
