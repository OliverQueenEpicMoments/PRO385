extends CharacterBody2D

@onready var Static = $TVStatic
var PlayerLocation = Vector2(0, 0)
var EnemyLocation = Vector2(0, 0)

@export var Speed = 100.0
@export var SprintSpeed = 200.0
@export var Acceleration = 10.0

@export var StaminaMax = 100.0
var StaminaCurrent = 100.0: set = SetStamina
@export var StaminaDrainRate = 10.0
@export var StaminaRegenRate = 5.0
var StaminaRegenReady = false
var IsRunning = false

@export var MaxSanity = 100
@export var InsanityMultiplier = 1.75
var CurrentSanity = 0
var LosingSanity = false

@onready var timer = $Timer

signal StaminaChanged()

func SetStamina(value):
	var OldValue = StaminaCurrent
	StaminaCurrent = value
	StaminaChanged.emit()
	

func _process(delta):
	LoseSanity(delta)
	PlayerLocation = global_position
	#print(PlayerLocation)
	if (CurrentSanity >= 25):
		pass

func	_physics_process(delta: float) -> void:
	var Direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	var CurrentSpeed = Speed
	
	if Input.is_action_pressed("Sprint") and StaminaCurrent > 0:
		StaminaRegenReady = false
		IsRunning = true
		CurrentSpeed = SprintSpeed
		StaminaCurrent -= StaminaDrainRate * delta
	else:
		IsRunning = false
		if Input.is_action_just_released("Sprint") and StaminaCurrent < 100:
			#print("Start Timer")
			timer.start()
			
		if (StaminaRegenReady):
			StaminaCurrent = clamp(StaminaCurrent + StaminaRegenRate * delta, 0, StaminaMax)
		
	velocity.x = move_toward(velocity.x, CurrentSpeed * Direction.x, Acceleration)
	velocity.y = move_toward(velocity.y, CurrentSpeed * Direction.y, Acceleration)

	move_and_slide()


func _on_timer_timeout():
	if (!IsRunning):
		StaminaRegenReady = true
		


func _on_area_2d_body_entered(body):
	if (body.has_method("InflictFear")):
		LosingSanity = true
		EnemyLocation = body.global_position
		#print(EnemyLocation)


func _on_area_2d_body_exited(body):
	if (body.has_method("InflictFear")):
		LosingSanity = false
		Static.visible = false


func LoseSanity(time):
	var MaxDistance = 185
	var Distance = PlayerLocation.distance_to(EnemyLocation)
	var AdjustedMultiplier = InsanityMultiplier * (MaxDistance - Distance) / MaxDistance # Scales the multiplier inversely with distance
	if (LosingSanity):
		CurrentSanity = clamp(CurrentSanity + AdjustedMultiplier * InsanityMultiplier * time, 0, MaxSanity)
		Static.visible = true
		Static.modulate = StaticIntensity(Color(1, 1, 1), Color(0.275, 0.275, 0.275), Distance / 180)
		
		print("Player Sanity - ", CurrentSanity)


func StaticIntensity(color1: Color, color2: Color, weight: float) -> Color:
	return color1.lerp(color2, weight)


func Player():
	pass
