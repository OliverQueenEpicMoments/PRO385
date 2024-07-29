extends Area2D

signal Stunned()
signal Unstunned()

func _on_body_entered(body):
	Stunned.emit()
	#print("Puppet Stunned")

func _on_body_exited(body):
	Unstunned.emit()
	#print("Puppet Freed")
