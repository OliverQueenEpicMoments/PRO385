extends Node2D

@export var BatteryMax = 100.0
var BatteryCurrent = 100.0: set = SetBattery
@export var BatteryDrainRate = 5.0
@onready var FlashlightLight = $PointLight2D

var IsActive = false

signal BatteryChanged()


# Called when the node enters the scene tree for the first time.
func _ready():
	FlashlightLight.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_released("Flashlight")):
		if (IsActive):
			IsActive = false
		else: 
			IsActive = true

			
	if (IsActive and BatteryCurrent > 0):
		BatteryCurrent -= BatteryDrainRate * delta
		FlashlightLight.enabled = true
	else:
		FlashlightLight.enabled = false


func	_physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func SetBattery(value):
	var OldValue = BatteryCurrent
	BatteryCurrent = value
	BatteryChanged.emit()
