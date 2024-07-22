extends Node

# Player
@onready var Player
var PlayerSanity: = 0.0
var MaxInsanity: = false

# Inventory
var PlayerInventory: = []
signal InventoryUpdated
@onready var InvSlotScene = preload("res://Scenes/Inventory/InventorySlot.tscn")

# Settings
var IsPaused: = false
var FullscreenIndex: = 2
var Borderless: = false

func _ready():
	Player = get_tree().get_first_node_in_group("Player")
	PlayerInventory.resize(18)

func SetSanity(sanity):
	PlayerSanity = sanity
	
	if (PlayerSanity >= 100):
		MaxInsanity = true
	else:
		MaxInsanity = false

func AddItem(item):
	for I in range(PlayerInventory.size()):
		if (PlayerInventory[I] != null and PlayerInventory[I]["Type"] == item["Type"] and PlayerInventory[I]["Effect"] == item["Effect"]):
			PlayerInventory[I]["Quantity"] += item["Quantity"]
			InventoryUpdated.emit()
			print("Item added ", PlayerInventory)
			return true
		elif (PlayerInventory[I] == null):
			PlayerInventory[I] = item
			InventoryUpdated.emit()
			print("Item added ", PlayerInventory)
			return true
	return false

func RemoveItem():
	InventoryUpdated.emit()

func IncreaseInventorySize():
	InventoryUpdated.emit()
