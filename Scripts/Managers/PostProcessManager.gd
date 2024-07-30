extends Node

var MinVignetteIntensity = 0.8
var MaxVignetteIntensity = 1.5
var MinVignetteOpacity = 0.75
var MaxVignetteOpacity = 1.0

var MinCAStrength = 0.0
var MaxCAStrength = 2.5

var MinGrainPower = 25.0
var MaxGrainPower = 75.0

func EffectsLogic(sanity):
	# Checks to see if a PostProecessing nide exists before changing its variables
	if (is_instance_valid(Global.PostProcess)):
		Global.PostProcess.configuration.VignetteIntensity = lerp(MinVignetteIntensity, MaxVignetteIntensity, sanity / 100)
		Global.PostProcess.configuration.VignetteOpacity = lerp(MinVignetteOpacity, MaxVignetteOpacity, sanity / 100)
		Global.PostProcess.configuration.GrainPower = lerp(MinGrainPower, MaxGrainPower, sanity / 100)
		Global.PostProcess.configuration.StrenghtCA = lerp(MinCAStrength, MaxCAStrength, sanity / 100)
	else: 
		Global.PostProcess = get_tree().get_first_node_in_group("PostProcessing")
	
	if (sanity < 25):
		Global.PostProcess.configuration.ScreenShake = false
		Global.PostProcess.configuration.Grain = false
	elif (sanity >= 25 and sanity < 50):
		Global.PostProcess.configuration.Grain = true
		Global.PostProcess.configuration.ChromaticAberration = false
	elif (sanity >= 50 and sanity < 100):
		Global.PostProcess.configuration.ChromaticAberration = true
		Global.PostProcess.configuration.ScreenShake = false
	elif (sanity >= 100):
		Global.PostProcess.configuration.ScreenShake = true


func _ready():
	Global.PostProcess = get_tree().get_first_node_in_group("PostProcessing")
	
