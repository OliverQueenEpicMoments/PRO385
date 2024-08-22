extends Node2D

@export_category("Enemy Scenes")
@export var EyeEnemyScene : PackedScene 
@export var PuppetEnemyScene : PackedScene 
@export var IdolEnemyScene : PackedScene 

@export_category("Lights")
@onready var RoomLight = $GenericLight
@export var LightPosition: Node2D
@export var LightScale: int = 1
@export var HasLight: = true

@export_category("Spawn Logic")
@export var EyeSpawnArea : CollisionPolygon2D
@export var RoomArea : CollisionShape2D
@export var PuppetSpawns : Array[Node2D] = []
@export var IdolSpawns : Array[Node2D] = []
@export var MinimumSpawnDistance: = 100.0 
@export var PeacefulRoom: = false
@export var NonLethalSpawned: = false
@export var SpawnDelay: = 1.0 

@export_category("Enemy Logic")
@export var MinEnemies: = 2
@export var MaxEnemies: = 5  

@export_category("Camera")
@export var RoomPhantomCam : PhantomCamera2D
@export var CameraZoom : float = 3.5 

func _ready():
	$SpawnTimer.wait_time = SpawnDelay
	
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
	
	RoomPhantomCam.set_zoom(Vector2(CameraZoom, CameraZoom))
	
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

func SpawnPuppet():
	var FurthestSpawnPoint = GetFurthestSpawnPoint()
	if FurthestSpawnPoint:
		var PuppetInstance = PuppetEnemyScene.instantiate()
		PuppetInstance.position = FurthestSpawnPoint.global_position
		add_child(PuppetInstance)

func SpawnIdol():
	var SafeSpawnPoint = GetSafeSpawnPoint()
	if SafeSpawnPoint:
		var IdolInstance = IdolEnemyScene.instantiate()
		IdolInstance.position = SafeSpawnPoint.global_position
		add_child(IdolInstance)

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
	
func GetFurthestSpawnPoint() -> Node2D:
	var FurthestSpawn: Node2D = null
	var MaxDistance: float = -INF

	for SpawnPoint in PuppetSpawns:
		var Distance = Global.Player.global_position.distance_to(SpawnPoint.global_position)
		if Distance > MaxDistance:
			MaxDistance = Distance
			FurthestSpawn = SpawnPoint

	return FurthestSpawn
	
func GetSafeSpawnPoint() -> Node2D:
	var SafeSpawnPoints = []
	
	for SpawnPoint in IdolSpawns:
		if Global.Player and SpawnPoint:
			var distance_to_player = Global.Player.global_position.distance_to(SpawnPoint.global_position)
			if distance_to_player >= MinimumSpawnDistance:
				SafeSpawnPoints.append(SpawnPoint)
	
	# Randomly select a safe spawn point from the list, if any
	if SafeSpawnPoints.size() > 0:
		return SafeSpawnPoints[randi() % SafeSpawnPoints.size()]
	else:
		return null  # Return null if no safe spawn point is found

func _on_room_area_body_entered(body):
	RoomPhantomCam.set_priority(1)
	#print("Entered room cam priority - ", RoomPhantomCam.get_priority())
	$SpawnTimer.start()

func _on_room_area_body_exited(body):
	RoomPhantomCam.set_priority(0)
	RoomPhantomCam.set_zoom(Vector2(3.5, 3.5))
	#print("Exited room cam priority - ", RoomPhantomCam.get_priority())
	Global.DespawnEnemies()

func _on_spawn_timer_timeout():
	if !HasLight and !PeacefulRoom:
		var Rand = randf()
		if (Rand < 0.4):
			SpawnEyes(randi_range(MinEnemies, MaxEnemies))
			NonLethalSpawned = true
		elif Rand >= 0.4 and Rand < 0.8:
			SpawnIdol()
			NonLethalSpawned = true
		
		Rand = randf()
		if NonLethalSpawned:
			if (Rand < 0.33):  # Lower chance if an enemy is already spawned
				SpawnPuppet()
		else:
			if (Rand > 0.33): 
				SpawnPuppet()
