@tool
extends Node2D

@onready var InteractionArea = $InteractionArea

@export_category("Item Data")
@export var ItemType: = ""
@export var ItemName: = ""
@export var ItemTexture : Texture
@export var ItemEffect: = ""
@export var ItemDescription: = ""

@export_category("Scaling Settings")
@export var SpriteScale: = 1.0
@export var HitboxScale: = 1.0

var ScenePath: = "res://Scenes/Inventory/InventoryItem.tscn"

@onready var IconSprite = $Sprite2D

func _ready():
	InteractionArea.Interact = Callable(self, "OnInteract")
	if (!Engine.is_editor_hint()):
		IconSprite.texture = ItemTexture
		IconSprite.scale = Vector2(SpriteScale, SpriteScale)
		$InteractionArea.scale = Vector2(HitboxScale, HitboxScale)

func _process(delta):
	if (Engine.is_editor_hint()):
		IconSprite.texture = ItemTexture
		IconSprite.scale = Vector2(SpriteScale, SpriteScale)
		$InteractionArea.scale = Vector2(HitboxScale, HitboxScale)

func OnInteract():
	print(ItemName, " has been picked up")
	var CurrentItem: = {
		"Quantity" : 1,
		"Type" : ItemType,
		"Name" : ItemName,
		"Effect" : ItemEffect,
		"Description" : ItemDescription,
		"Texture" : ItemTexture,
		"ScenePath" : ScenePath
	}
	
	if (Global.Player):
		Global.AddItem(CurrentItem)
		self.queue_free()

func SetItemData(data):
	ItemType = data["Type"]
	ItemName = data["Name"]
	ItemEffect = data["Effect"]
	ItemTexture = data["Texture"]
