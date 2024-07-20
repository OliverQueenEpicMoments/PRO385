extends Control

@onready var SettingsUI: = get_tree().get_first_node_in_group("SettingsMenu")
@onready var AnimPlayer = $AnimationPlayer

func Pause():
	show()
	get_tree().paused = true
	AnimPlayer.play("Blur")
	
func Resume():
	$PauseMusic.stop()
	if (SettingsUI.is_visible()):
		SettingsUI.Uninitialize()
		show()
	
	get_tree().paused = false
	AnimPlayer.play_backwards("Blur")

func _unhandled_input(_event):
	if (Input.is_action_just_pressed("Pause") and !get_tree().paused):
		$PauseMusic.play()
		if (SettingsUI.is_visible()):
			SettingsUI.Uninitialize()
			$SettingsTimer.start()
		else:
			Pause()
	elif (Input.is_action_just_pressed("Pause") and get_tree().paused):
		if (!SettingsUI.is_visible()):
			Resume()
			show()
		else:
			SettingsUI.Uninitialize()

func _on_resume_button_pressed():
	Resume()

func _on_restart_button_pressed():
	Resume()
	get_tree().reload_current_scene() 

func _on_settings_button_pressed():
	AnimPlayer.play_backwards("Blur")
	$Timer.start()

func _on_quit_button_pressed():
	get_tree().quit()

func _ready():
	AnimPlayer.play("RESET")
	show()

func _on_timer_timeout():
	hide()
	SettingsUI.Initialize()

func _on_settings_timer_timeout():
	Pause()

func _on_main_menu_button_pressed():
	Resume()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
