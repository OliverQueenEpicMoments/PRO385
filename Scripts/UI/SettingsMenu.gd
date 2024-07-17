extends Control

@onready var MasterSlider: = $PanelContainer/VBoxContainer/MasterSlider
@onready var MusicSlider: = $PanelContainer/VBoxContainer/MusicSlider
@onready var SFXSlider: = $PanelContainer/VBoxContainer/SFXSlider

@onready var MasterBus = AudioServer.get_bus_index("Master")
@onready var MusicBus = AudioServer.get_bus_index("Music")
@onready var SFXBus = AudioServer.get_bus_index("SFX")

func _ready():
	MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MasterBus))
	MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MusicBus))
	SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(SFXBus))

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MasterBus, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MusicBus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFXBus, linear_to_db(value))
