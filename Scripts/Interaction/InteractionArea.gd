extends Area2D
class_name InteractionArea

@export var ActionName: String = "Interact"

var Interact: Callable = func ():
	pass

func _on_body_entered(body):
	InteractionManager.RegisterArea(self)


func _on_body_exited(body):
	InteractionManager.UnregisterArea(self)
