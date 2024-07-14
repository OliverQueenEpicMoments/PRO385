extends Node

@onready var PostProcess

var MinVignetteIntensity = 0.8
var MaxVignetteIntensity = 1.5
var MinVignetteOpacity = 0.75
var MaxVignetteOpacity = 1.0

var MinCAStrength = 0.0
var MaxCAStrength = 2.0

var MinGrainPower = 25.0
var MaxGrainPower = 75.0

func EffectsLogic(sanity):
	PostProcess.configuration.VignetteIntensity = lerp(MinVignetteIntensity, MaxVignetteIntensity, sanity / 100)
	PostProcess.configuration.VignetteOpacity = lerp(MinVignetteOpacity, MaxVignetteOpacity, sanity / 100)
	PostProcess.configuration.GrainPower = lerp(MinGrainPower, MaxGrainPower, sanity / 100)
	PostProcess.configuration.StrenghtCA = lerp(MinCAStrength, MaxCAStrength, sanity / 100)
	
	if (sanity < 25):
		PostProcess.configuration.ScreenShake = false
		PostProcess.configuration.Grain = false
	elif (sanity >= 25 and sanity < 50):
		PostProcess.configuration.Grain = true
		PostProcess.configuration.ChromaticAberration = false
	elif (sanity >= 50 and sanity < 100):
		PostProcess.configuration.ChromaticAberration = true
		PostProcess.configuration.ScreenShake = false
	elif (sanity >= 100):
		PostProcess.configuration.ScreenShake = true


func _ready():
	PostProcess = get_tree().get_first_node_in_group("PostProcessing")
	
