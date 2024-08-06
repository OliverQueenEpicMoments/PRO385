extends Control


func OnDeath():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("Fade")

func _on_respawn_button_pressed():
	# TODO Implement respawn mechanic with checkpoints in mind
	get_tree().paused = false
	get_tree().reload_current_scene() 

func _on_menu_button_pressed():
	Global.NewGame()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
