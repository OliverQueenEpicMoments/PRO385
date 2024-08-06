extends CharacterBody2D

@onready var Static = $TVStatic
var PlayerLocation = Vector2(0, 0)
var EnemyLocation = Vector2(0, 0)

@export var MaxHealth: = 3
var CurrentHealth

@export var Speed = 100.0
@export var SprintSpeed = 150.0
@export var Acceleration = 10.0
@export var IsRooted = false

@export var StaminaMax: = 100.0
var StaminaCurrent: = 100.0: set = SetStamina
@export var StaminaDrainRate: = 10.0
@export var StaminaRegenRate: = 5.0
var StaminaRegenReady: = false
var IsRunning: = false

@export var MaxSanity: = 100.0
@export var InsanityMultiplier: = 1.75
var CurrentSanity: = 0.0
var LosingSanity: = false
var BeingWatched: = false

@onready var timer = $Timer
@onready var SoundsTimer = $SoundTimer
var TimerStarted = false

@onready var Alarm = $Alarm
@onready var Knocking = $Knocking
@onready var Footsteps = $Footsteps
@onready var InsanityBackground = $InsanityBackground

var SoundProbability: = [true, false]

signal StaminaChanged()

func SetStamina(value):
	var OldValue = StaminaCurrent
	StaminaCurrent = value
	StaminaChanged.emit()	

func _process(delta):
	LoseSanity(delta)
	#EyeInsanity(delta, 0.2)
	Dialogic.VAR.PlayerSanity = CurrentSanity
	PostProcessManager.EffectsLogic(CurrentSanity)
	InsanitySounds()
	PlayerLocation = global_position
	
func _ready():
	CurrentSanity = Global.PlayerSanity
	CurrentHealth = MaxHealth

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
		Global.SetSanity(CurrentSanity)
		
		print("Player Sanity - ", CurrentSanity)
		
func EyeInsanity(insanity):
	CurrentSanity = clamp(CurrentSanity + insanity, 0, MaxSanity)
	Global.SetSanity(CurrentSanity)
		
	print("Player Sanity - ", CurrentSanity)

func StaticIntensity(color1: Color, color2: Color, weight: float) -> Color:
	return color1.lerp(color2, weight)

func InsanitySounds():
	if (CurrentSanity >= 100 and !InsanityBackground.playing):
		InsanityBackground.play()
		if (!TimerStarted):
			SoundsTimer.start()
			TimerStarted = true
	elif (CurrentSanity < 100):
		InsanityBackground.stop()

func Player():
	pass

func _on_sound_timer_timeout():
	var Rand = randf()
	print("Timer proced - ", Rand)
	if (Rand < 0.1 and Rand >= 0.05):
		Knocking.play()
	elif (Rand < 0.05):
		Alarm.play()
		
func ApplyItemEffect(item):
	match item["Effect"]:
		"Charge":
			$Flashlight.AddCharge(25)
		"Full Charge":
			$Flashlight.AddCharge(100)
		"Inventory Small":
			Global.IncreaseInventorySize(2)
		_:
			print("No item effect")

func ApplyHeal(heal):
	CurrentHealth = clamp(CurrentHealth + heal, 0, MaxHealth)

func ApplyDamage(damage):
	CurrentHealth = clamp(CurrentHealth - damage, 0, MaxHealth)
	if CurrentHealth <= 0:
		Death()

func Death():
	Global.PlayerDeath()

func _on_damage_body_entered(body):
	#dprint("Hit by ", body)
	ApplyDamage(body.GetDamage())
