extends Node2D

@export_category("Enemy Scenes")
@export var EyeEnemyScene : PackedScene 
@export var PuppetEnemyScene : PackedScene 
@export var IdolEnemyScene : PackedScene 

@export_category("Lights")
@onready var RoomLight = $GenericLight
@export var LightPosition: Node2D
@export var LightScale: int
@export var HasLight: = true

@export_category("Spawn Logic")
@export var EyeSpawnArea : CollisionPolygon2D
@export var RoomArea : CollisionShape2D
@export var PuppetSpawns : Array[Node2D] = []
@export var IdolSpawns : Array[Node2D] = []
@export var MinimumSpawnDistance: = 100.0 

@export_category("Enemy Logic")
@export var MinEnemies: = 2
@export var MaxEnemies: = 5  

var Enemies: = []

func _ready():
	# Light setup
	if is_instance_valid(RoomLight):
		RoomLight.global_position = LightPosition.global_position
		RoomLight.scale = Vector2(LightScale, LightScale)
	
	# Room hitbox setup
	var BoxTransform = RoomArea.global_position
	var BoxSize = RoomArea.shape.get_rect().size / 2
	var Shape = RectangleShape2D.new()
	
	RoomArea = CollisionShape2D.new()
	RoomArea.global_position = BoxTransform
	Shape.extents = BoxSize
	RoomArea.shape = Shape
	$RoomArea.add_child(RoomArea)
	
	set_process(true)

func _process(delta):
	if !HasLight:
		RoomLight.StopsPuppet = false
		RoomLight.hide()
	else:
		RoomLight.StopsPuppet = true
		RoomLight.show()

func SpawnEyes(amount):
	for I in range(amount):
		var EnemyInstance = EyeEnemyScene.instantiate()
		var Position = GetRandomBoundsPosition(EyeSpawnArea.polygon)
		EnemyInstance.position = Position
		add_child(EnemyInstance)
		Enemies.append(EnemyInstance)
		EnemyInstance.connect("tree_exited", Callable(self, "OnEnemyRemoved"))

func SpawnPuppet():
	var SafeSpawnPoint = GetSafeSpawnPoint()
	if SafeSpawnPoint:
		var PuppetInstance = PuppetEnemyScene.instantiate()
		PuppetInstance.position = SafeSpawnPoint.global_position
		add_child(PuppetInstance)
		Enemies.append(PuppetInstance)
		PuppetInstance.connect("tree_exited", Callable(self, "OnEnemyRemoved"))

func GetRandomBoundsPosition(polygon):
	while true:
		var MinX = INF
		var MaxX = -INF
		var MinY = INF
		var MaxY = -INF
		
		for point in polygon:
			if point.x < MinX:
				MinX = point.x
			if point.x > MaxX:
				MaxX = point.x
			if point.y < MinY:
				MinY = point.y
			if point.y > MaxY:
				MaxY = point.y
		
		var RandomPoint = Vector2(randf_range(MinX, MaxX), randf_range(MinY, MaxY))
		
		if IsPointInPolygon(RandomPoint, polygon):
			return RandomPoint

func IsPointInPolygon(point, polygon):
	var Inside = false
	var J = polygon.size() - 1 
	for I in range(polygon.size()):
		if ((polygon[I].y > point.y) != (polygon[J].y > point.y)) and \
			(point.x < (polygon[J].x - polygon[I].x) * (point.y - polygon[I].y) / (polygon[J].y - polygon[I].y) + polygon[I].x):
			Inside = not Inside
		J = I
	return Inside
	
func GetSafeSpawnPoint() -> Node2D:
	var SafeSpawnPoints = []
	
	for point in PuppetSpawns:
		if Global.Player and point:
			var distance_to_player = Global.Player.global_position.distance_to(point.global_position)
			if distance_to_player >= MinimumSpawnDistance:
				SafeSpawnPoints.append(point)
	
	# Randomly select a safe spawn point from the list, if any
	if SafeSpawnPoints.size() > 0:
		return SafeSpawnPoints[randi() % SafeSpawnPoints.size()]
	else:
		return null  # Return null if no safe spawn point is found
	
func OnEnemyRemoved(enemy):
	Enemies.erase(enemy)
	print(Enemies)

func _on_room_area_body_entered(body):
	if !HasLight:
		SpawnEyes(randi_range(MinEnemies, MaxEnemies))
		SpawnPuppet()

func _on_room_area_body_exited(body):
	# TODO Logic here for deleting all enemies in the scene, probably with an enemy group assigned to all enemies
	pass # Replace with function body.
