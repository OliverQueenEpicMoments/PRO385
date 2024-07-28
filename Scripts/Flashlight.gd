extends Node2D

@export var BatteryMax: = 100.0
var BatteryCurrent: = 100.0: set = SetBattery
@export var BatteryDrainRate: = 3.0
@onready var FlashlightLight = $PointLight2D
@onready var ShadowLight = $ShadowLight
@onready var LOSLight = $LOSLight
@onready var LightCollider = $Area2D/CollisionPolygon2D

var IsActive = false

signal BatteryChanged()

# Called when the node enters the scene tree for the first time.
func _ready():
	FlashlightLight.enabled = false
	ShadowLight.enabled = false
	LOSLight.enabled = false
	LightCollider.disabled = true

func _unhandled_input(_event):
	if (Input.is_action_just_released("Flashlight")):
		$AudioStreamPlayer2D.play()
		if (IsActive):
			IsActive = false
		else: 
			IsActive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (IsActive and BatteryCurrent > 0):
		BatteryCurrent -= BatteryDrainRate * delta
		FlashlightLight.enabled = true
		ShadowLight.enabled = true
		LOSLight.enabled = true
		LightCollider.disabled = false
	else:
		FlashlightLight.enabled = false
		ShadowLight.enabled = false
		LOSLight.enabled = false
		LightCollider.disabled = true

func	_physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func SetBattery(value):
	var OldValue = BatteryCurrent
	BatteryCurrent = value
	BatteryChanged.emit()

func AddCharge(chargeval):
	BatteryCurrent = clamp(BatteryCurrent + chargeval, 0, BatteryMax)

func _on_area_2d_body_entered(body):
	#print(body)
	pass
