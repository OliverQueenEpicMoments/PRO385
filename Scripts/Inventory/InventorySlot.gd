extends Control

@onready var InvUI: = get_tree().get_first_node_in_group("InventoryUI")

@onready var ItemIcon = $Border/ItemIcon
@onready var QuantityLabel = $Border/VBoxContainer/Panel/Title/QuantityLabel

var CurrentItem = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_button_pressed():
	if (CurrentItem != null):
		InvUI.SetItemDetails(CurrentItem)

func _on_item_button_mouse_entered():
	pass

func _on_item_button_mouse_exited():
	pass

func SetEmpty():
	ItemIcon.texture = null
	QuantityLabel.text = ""

func SetItem(item):
	CurrentItem = item
	ItemIcon.texture = item["Texture"]
	QuantityLabel.text = str(item["Quantity"])
