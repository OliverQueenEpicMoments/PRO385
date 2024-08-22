extends Control

func _ready() -> void:
	$AnimationPlayer.play_backwards("Fade")

func StartTransition():
	$AnimationPlayer.play("Fade")
	#$AudioStreamPlayer2D.play()

func EndTransition():
	$AnimationPlayer.play_backwards("Fade")
