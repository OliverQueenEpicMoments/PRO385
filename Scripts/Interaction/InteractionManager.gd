extends Node2D

@onready var Player: = get_tree().get_first_node_in_group("Player")
@onready var label: = $Label

const BaseText = "[E] to "

var ActiveAreas = []
var CanInteract: = true


func RegisterArea(area: InteractionArea):
	ActiveAreas.push_back(area)
	
func UnregisterArea(area: InteractionArea):
	var Index = ActiveAreas.find(area)
	if (Index != -1):
		ActiveAreas.remove_at(Index)

func SortByDistanceToPlayer(area1, area2):
	# TODO Check if player exists before executing this code
	var Area1ToPlayer = Player.global_position.distance_to(area1.global_position)
	var Area2ToPlayer = Player.global_position.distance_to(area2.global_position)
	return Area1ToPlayer < Area2ToPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ActiveAreas.size() > 0 and CanInteract):
		ActiveAreas.sort_custom(SortByDistanceToPlayer)
		label.text = BaseText + ActiveAreas[0].ActionName
		label.global_position = ActiveAreas[0].global_position
		label.global_position.y -= 64
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()

func _input(event):
	if (event.is_action_pressed("Interact") and CanInteract):
		if (ActiveAreas.size() > 0):
			CanInteract = false
			label.hide()
			
			await ActiveAreas[0].Interact.call()
			
			CanInteract = true
