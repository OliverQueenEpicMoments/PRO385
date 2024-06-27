extends CanvasLayer


@onready var player = %PrototypePlayer
@onready var StaminaBar = $PlayerInfoBox/StaminaBar
@onready var FlashlightBar = $PlayerInfoBox/FlashlightBar

func _ready():
	player.StaminaChanged.connect(Update)
	Update()

func Update():
	StaminaBar.value = player.StaminaCurrent
