extends Control

@export var PuppetDesc : EnemyDesc
@export var InsanitytDesc : EnemyDesc

@onready var EnemyName = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var EnemyIcon = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var CauseOfDeath = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TypeLabel
@onready var Description = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/EffectTextLabel
@onready var ExtraDescription = $DescriptionPanel/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/DescriptionLabel

func OnDeath():
	match Global.CauseOfDeath:
		"Puppet":
			EnemyName.text = PuppetDesc.EnemyName
			EnemyIcon.texture = PuppetDesc.EnemyIcon
			CauseOfDeath.text = PuppetDesc.CauseOfDeath
			Description.text = PuppetDesc.EnemyDescription
			ExtraDescription.text = PuppetDesc.ExtraDescription
		"Insanity":
			EnemyName.text = InsanitytDesc.EnemyName
			EnemyIcon.texture = InsanitytDesc.EnemyIcon
			CauseOfDeath.text = InsanitytDesc.CauseOfDeath
			Description.text = InsanitytDesc.EnemyDescription
			ExtraDescription.text = InsanitytDesc.ExtraDescription
	
	show()
	get_tree().paused = true
	$AnimationPlayer.play("Fade")

func _on_respawn_button_pressed():
	# TODO Implement respawn mechanic with checkpoints in mind
	Global.NewGame()
	get_tree().paused = false
	get_tree().reload_current_scene() 

func _on_menu_button_pressed():
	Global.NewGame()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func _on_quit_button_pressed():
	Global.NewGame()
	get_tree().quit()
