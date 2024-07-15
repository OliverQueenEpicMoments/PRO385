extends Control

@onready var AnimPlayer = $AnimationPlayer


func Pause():
	get_tree().paused = true
	AnimPlayer.play("Blur")
	
func Resume():
	get_tree().paused = false
	AnimPlayer.play_backwards("Blur")

func _unhandled_input(_event):
	if (Input.is_action_just_pressed("Pause") and !get_tree().paused):
		Pause()
	elif (Input.is_action_just_pressed("Pause") and get_tree().paused):
		Resume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_resume_button_pressed():
	Resume()

func _on_restart_button_pressed():
	Resume()
	get_tree().reload_current_scene() 

func _on_settings_button_pressed():
	pass #TODO Implement settings and settings menu

func _on_quit_button_pressed():
	get_tree().quit()

func _ready():
	AnimPlayer.play("RESET")
