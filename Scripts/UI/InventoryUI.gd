extends Control

@onready var ItemContainer = $InventoryPanel/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

@onready var DescriptionPanel = $DescriptionPanel
@onready var ItemIcon = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var ItemName = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var ItemType = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TypeLabel
@onready var ItemEffect = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/EffectTextLabel
@onready var ItemDescription = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/DescriptionLabel

var CurrentItem = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.InventoryUpdated.connect(OnInventoryUpdated)
	OnInventoryUpdated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(_event):
	if (Input.is_action_just_pressed("Inventory") and !self.is_visible()):
		$InventoryPanel/InventoryAnimation.play("Fade")
	elif (Input.is_action_just_pressed("Inventory") and self.is_visible()):
		$InventoryPanel/InventoryAnimation.play_backwards("Fade")

func Uninitialize():
	$InventoryPanel/InventoryAnimation.play_backwards("Fade")
	if (DescriptionPanel.is_visible()):
		$DescriptionPanel/DetailedAnimation.play_backwards("Fade")

func OnInventoryUpdated():
	ClearGridContainer()
	for item in Global.PlayerInventory:
		var InvSlot = Global.InvSlotScene.instantiate()
		ItemContainer.add_child(InvSlot)
		
		if (item != null):
			InvSlot.SetItem(item)
		else:
			InvSlot.SetEmpty()
	
func ClearGridContainer():
	while (ItemContainer.get_child_count() > 0):
		var Child = ItemContainer.get_child(0)
		ItemContainer.remove_child(Child)
		Child.queue_free()

func SetItemDetails(item):
	CurrentItem = item
	print(CurrentItem)
	if (!DescriptionPanel.is_visible()):
		$DescriptionPanel/DetailedAnimation.play("Fade")
	
	ItemIcon.texture = item["Texture"]
	ItemName.text = str(item["Name"])
	ItemType.text = str(item["Type"])
	ItemDescription.text = item["Description"]
	
	if (item["Effect"] != ""):
		ItemEffect.text = str("+ ", item["Effect"])
	else:
		ItemEffect.text = ""


func _on_discard_button_pressed():
	if (CurrentItem != null):
		var DropPosition = Global.Player.global_position
		var DropOffset = Vector2(0, 50)
		DropOffset = DropOffset.rotated( Global.Player.rotation)
		Global.DropItem(CurrentItem, DropPosition + DropOffset)
		Global.RemoveItem(CurrentItem["Type"], CurrentItem["Effect"])
		$DescriptionPanel/DetailedAnimation.play_backwards("Fade")

func _on_use_button_pressed():
	$DescriptionPanel/DetailedAnimation.play_backwards("Fade")
	if (CurrentItem != null and CurrentItem["Effect"] != ""):
		if (Global.Player):
			Global.Player.ApplyItemEffect(CurrentItem)
			Global.RemoveItem(CurrentItem["Type"], CurrentItem["Effect"])
		else:
			print("Player not found")
