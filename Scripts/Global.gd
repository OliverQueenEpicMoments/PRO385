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

@onready var PostProcess

func _ready():
	Player = get_tree().get_first_node_in_group("Player")
	PostProcess = get_tree().get_first_node_in_group("PostProcessing")
	PlayerInventory.resize(16)

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

func RemoveItem(itemtype, itemeffect):
	for I in range(PlayerInventory.size()):
		if (PlayerInventory[I] != null and PlayerInventory[I]["Type"] == itemtype and PlayerInventory[I]["Effect"] == itemeffect):
			PlayerInventory[I]["Quantity"] -= 1
			if (PlayerInventory[I]["Quantity"] <= 0):
				PlayerInventory[I] = null
			InventoryUpdated.emit()
			return true
	return false

func IncreaseInventorySize(extraslots):
	PlayerInventory.resize(PlayerInventory.size() + extraslots)
	InventoryUpdated.emit()

func AdjustDropPosition(position):
	var Radius = 100
	var NearbyItems = get_tree().get_nodes_in_group("Items")
	for DroppedItem in NearbyItems:
		if (DroppedItem.global_position.distance_to(position) < Radius):
			var RandOffset = Vector2(randf_range(-Radius, Radius), randf_range(-Radius, Radius))
			position += RandOffset
			break
	return position
	
func DropItem(itemdata, dropposition):
	var ItemScene = load(itemdata["ScenePath"])
	var ItemInstance = ItemScene.instantiate()
	ItemInstance.SetItemData(itemdata)
	dropposition = AdjustDropPosition(dropposition)
	ItemInstance.global_position = dropposition
	get_tree().current_scene.add_child(ItemInstance)

func GetPlayer():
	Player = get_tree().get_first_node_in_group("Player")
