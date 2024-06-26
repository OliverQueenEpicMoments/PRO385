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

@export var Sanity = 0

@onready var timer = $Timer

signal StaminaChanged()

func SetStamina(value):
	var OldValue = StaminaCurrent
	StaminaCurrent = value
	StaminaChanged.emit()


func	_physics_process(delta: float) -> void:
	var Direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	var CurrentSpeed = Speed
	
	#look_at(get_global_mouse_position())
	
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
