extends Node2D

@export var BatteryMax = 100.0
var BatteryCurrent = 100.0: set = SetBattery
@export var BatteryDrainRate = 5.0
@onready var FlashlightLight = $PointLight2D
@onready var ShadowLight = $ShadowLight
@onready var LOSLight = $LOSLight

var IsActive = false

signal BatteryChanged()


# Called when the node enters the scene tree for the first time.
func _ready():
	FlashlightLight.enabled = false
	ShadowLight.enabled = false
	LOSLight.enabled = false


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
		ShadowLight.enabled = true
		LOSLight.enabled = true
	else:
		FlashlightLight.enabled = false
		ShadowLight.enabled = false
		LOSLight.enabled = false


func	_physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func SetBattery(value):
	var OldValue = BatteryCurrent
	BatteryCurrent = value
	BatteryChanged.emit()
