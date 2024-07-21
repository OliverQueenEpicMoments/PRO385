extends Control

@onready var ItemContainer = $Panel/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.InventoryUpdated.connect(OnInventoryUpdated)
	OnInventoryUpdated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(_event):
	if (Input.is_action_just_pressed("Inventory") and !self.is_visible()):
		$AnimationPlayer.play("Fade")
	elif (Input.is_action_just_pressed("Inventory") and self.is_visible()):
		$AnimationPlayer.play_backwards("Fade")

func Uninitialize():
	$AnimationPlayer.play_backwards("Fade")

func OnInventoryUpdated():
	ClearGridContainer()
	
func ClearGridContainer():
	while (ItemContainer.get_child_count() > 0):
		var Child = ItemContainer.get_child(0)
		ItemContainer.remove_child(Child)
		Child.queue_free()
