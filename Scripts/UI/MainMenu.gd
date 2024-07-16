extends Node2D

@onready var FadeAnim = $ColorRect
var NewGame = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.show()
	$ColorRect/FadeOutTimer.start()
	$ColorRect/AnimationPlayer.play("Fade")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_game_button_pressed():
	NewGame = true
	$ColorRect.show()
	$ColorRect/Timer.start()
	$ColorRect/AnimationPlayer.play_backwards("Fade")

func _on_continue_button_pressed():
	NewGame = false
	$ColorRect.show()
	$ColorRect/Timer.start()
	$ColorRect/AnimationPlayer.play_backwards("Fade")

func _on_settings_button_pressed():
	pass # TODO Pop up a settings menu

func _on_help_button_pressed():
	pass # TODO Pop up a help/tutorial menu

func _on_quit_button_pressed():
	get_tree().quit()

func _on_timer_timeout():
	if (NewGame):
		get_tree().change_scene_to_file("res://Scenes/Levels/game.tscn")
	else:
		pass # TODO Add functionality for loading a saved run

func _on_fade_out_timer_timeout():
	$ColorRect.hide()
	$ColorRect/AnimationPlayer.play("RESET")
