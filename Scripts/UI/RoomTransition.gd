extends Control


func StartTransition():
	$AnimationPlayer.play("Fade")
	#$AudioStreamPlayer2D.play()

func EndTransition():
	$AnimationPlayer.play_backwards("Fade")
