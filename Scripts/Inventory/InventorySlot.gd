extends Control

@onready var ItemIcon = $Border/ItemIcon
@onready var QuantityLabel = $Border/VBoxContainer/Panel/Title/QuantityLabel
@onready var MainPanel = $MainPanel
@onready var DetailsPanel = $MainPanel/Details
@onready var UsagePanel = $MainPanel/Usage
@onready var ItemName = $MainPanel/Details/Panel/ItemName
@onready var ItemType = $MainPanel/Details/Panel2/ItemType
@onready var ItemEffect = $MainPanel/Details/Panel3/ItemEffect

var CurrentItem = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_button_pressed():
	if (CurrentItem != null):
		#MainPanel.visible = !MainPanel.visible
		UsagePanel.visible = !UsagePanel.visible
		DetailsPanel.visible = false

func _on_item_button_mouse_entered():
	if (CurrentItem != null):
		MainPanel.visible = true
		UsagePanel.visible = false
		DetailsPanel.visible = true

func _on_item_button_mouse_exited():
	#MainPanel.visible = false
	DetailsPanel.visible = false

func SetEmpty():
	ItemIcon.texture = null
	QuantityLabel.text = ""

func SetItem(item):
	CurrentItem = item
	ItemIcon.texture = item["Texture"]
	QuantityLabel.text = str(item["Quantity"])
	ItemName.text = str(item["Name"])
	ItemType.text = str(item["Type"])
	
	if (CurrentItem["Effect"] != ""):
		ItemEffect.text = str("+ ", CurrentItem["Effect"])
	else:
		ItemEffect.text = ""
