extends Node2D

@onready var SettingsUI: = get_tree().get_first_node_in_group("SettingsMenu")

@onready var MenuUI = $CanvasLayer/ButtonManager
@onready var FadeAnim = $CanvasLayer/ButtonManager/AnimationPlayer
var NewGame = true

func Initialize():
	FadeAnim.play("Fade")

func _ready():
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/FadeOutTimer.start()
	$CanvasLayer/ColorRect/AnimationPlayer.play("Fade")
	FadeAnim.play("Fade")

func _on_new_game_button_pressed():
	NewGame = true
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/Timer.start()
	$CanvasLayer/ColorRect/AnimationPlayer.play_backwards("Fade")

func _on_continue_button_pressed():
	NewGame = false
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/Timer.start()
	$CanvasLayer/ColorRect/AnimationPlayer.play_backwards("Fade")

func _on_settings_button_pressed():
	FadeAnim.play_backwards("Fade")
	$CanvasLayer/ButtonManager/OtherFadeTimer.start()

func _on_help_button_pressed():
	FadeAnim.play_backwards("Fade")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_timer_timeout():
	if (NewGame):
		get_tree().change_scene_to_file("res://Scenes/Levels/game.tscn")
	else:
		pass # TODO Add functionality for loading a saved run

func _on_fade_out_timer_timeout():
	$CanvasLayer/ColorRect.hide()
	$CanvasLayer/ColorRect/AnimationPlayer.play("RESET")

func _on_other_fade_timer_timeout():
	SettingsUI.Initialize()
