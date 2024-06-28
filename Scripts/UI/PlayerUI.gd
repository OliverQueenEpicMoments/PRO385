extends CanvasLayer


@onready var player = %PrototypePlayer
@onready var Flashlight = %PrototypePlayer/Flashlight
@onready var StaminaBar = $PlayerInfoBox/StaminaBar
@onready var FlashlightBar = $PlayerInfoBox/FlashlightBar

func _ready():
	player.StaminaChanged.connect(Update)
	Flashlight.BatteryChanged.connect(Update)
	Update()

func Update():
	StaminaBar.value = player.StaminaCurrent
	FlashlightBar.value = Flashlight.BatteryCurrent
