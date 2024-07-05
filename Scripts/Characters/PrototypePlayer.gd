extends CharacterBody2D

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
@export var InsanityMultiplier = 1.5
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
	


func _on_area_2d_body_exited(body):
	if (body.has_method("InflictFear")):
		LosingSanity = false


func LoseSanity(time):
	if (LosingSanity):
		#CurrentSanity += 0.1
		CurrentSanity = clamp(CurrentSanity + InsanityMultiplier * time, 0, MaxSanity)
		print("Player sanity - ", CurrentSanity)


func Player():
	pass
