extends Node

@onready var Player: = get_tree().get_first_node_in_group("Player")

var InsanityEnemy: = preload("res://Scenes/Characters/Enemies/Mind'sBane.tscn")
var InsanityEnemySpawned: = false

func _ready():
	Player = Global.GetPlayer()

func _process(_delta):
	if (Global.MaxInsanity):
		if (!InsanityEnemySpawned):
			var Enemy = InsanityEnemy.instantiate()
			get_tree().current_scene.add_child(Enemy)
			InsanityEnemySpawned = true
