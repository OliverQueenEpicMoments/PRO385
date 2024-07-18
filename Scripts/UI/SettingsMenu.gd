extends Control

@onready var MenuUI: = get_tree().get_first_node_in_group("MainMenu")
@onready var PauseUI: = get_tree().get_first_node_in_group("PauseMenu")
@onready var AnimPlayer = $AnimationPlayer

@onready var DropDown = $PanelContainer/VBoxContainer/OptionButton
@onready var MasterSlider: = $PanelContainer/VBoxContainer/MasterSlider
@onready var MusicSlider: = $PanelContainer/VBoxContainer/MusicSlider
@onready var SFXSlider: = $PanelContainer/VBoxContainer/SFXSlider

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SFXBus = AudioServer.get_bus_index("SFX")

var SelectedResolution

var Resolutions: = {
	"800X600": Vector2i(800, 600),
	"1024X600": Vector2(1024, 600),
	"1440X600": Vector2(1440, 600),
	"1280X720": Vector2i(1280, 720),
	"1366X768": Vector2(1366, 768),
	"1600X900": Vector2(1600, 900),
	"1920X1080": Vector2i(1920, 1080),
	"2560X1494": Vector2i(2560, 1494),
	"2560X1600": Vector2i(2560, 1600),
	"2558X1598": Vector2i(2558, 1598),
	"2K": Vector2i(2560, 1440),
	"4K": Vector2i(3840, 2160)
}

func _ready():
	AnimPlayer.play("RESET")
	
	for R in Resolutions:
		DropDown.add_item(R)
	var WindowSize: = str(get_window().size.x, "X", get_window().size.y)
	if (WindowSize == "2560X1440"):
		WindowSize = "2K"
	elif (WindowSize == "3840X2160"):
		WindowSize = "4K"
	DropDown.selected = Resolutions.keys().find(WindowSize)
	print(WindowSize)
	
	$PanelContainer/VBoxContainer/CheckButton.button_pressed = Global.Borderless
	$PanelContainer/VBoxContainer/FullscreenModes.selected = Global.FullscreenIndex
		
	MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MasterBus))
	MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MusicBus))
	SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(SFXBus))
	if (!PauseUI):
		$PanelContainer/VBoxContainer/GameButton.hide()
	
func Initialize():
	if (PauseUI):
		get_tree().paused = true
	AnimPlayer.play("Fade")
		
func Uninitialize():
	AnimPlayer.play_backwards("Fade")
	$Timer.start()

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFXBus, linear_to_db(value))

func _on_back_button_pressed():
	AnimPlayer.play_backwards("Fade")
	$Timer.start()

func _on_timer_timeout():
	if (PauseUI):
		PauseUI.Pause()
	if (MenuUI):
		MenuUI.Initialize()
	hide()

func _on_game_button_pressed():
	AnimPlayer.play_backwards("Fade")
	get_tree().paused = false

func _on_option_button_item_selected(index):
	SelectedResolution = DropDown.get_item_text(index)
	#get_window().set_size(Resolutions[SelectedResolution])
	DisplayServer.window_set_size(Resolutions[SelectedResolution])
	print(Resolutions[SelectedResolution])

func _on_fullscreen_modes_item_selected(index):
	match index:
		0: # Fullscreen Exclusive
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			Global.FullscreenIndex = index
		1: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Global.FullscreenIndex = index
		2: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Global.FullscreenIndex = index
		3: # Maximized
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			Global.FullscreenIndex = index
		_:
			print("Uhhhh...")
	#get_window().set_size(Resolutions[SelectedResolution])


func _on_check_button_toggled(toggled_on):
	if (toggled_on):
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		Global.Borderless = true
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		Global.Borderless = false
