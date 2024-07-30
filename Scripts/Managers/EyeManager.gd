extends Node2D

@export var EnemyScene : PackedScene # Assign the enemy scene in the Inspector
@export var MinEnemies: = 2
@export var MaxEnemies: = 5  # Max number of enemies to spawn at a time

@export var SpawnArea : CollisionPolygon2D

var Enemies: = []

func _ready():
	SpawnEnemies(randi_range(MinEnemies, MaxEnemies))
	set_process(true)

func _process(delta):
	pass

func SpawnEnemies(amount):
	for I in range(amount):
		var EnemyInstance = EnemyScene.instantiate()
		var Position = GetRandomBoundsPosition(SpawnArea.polygon)
		EnemyInstance.position = Position
		add_child(EnemyInstance)
		Enemies.append(EnemyInstance)
		EnemyInstance.connect("tree_exited", Callable(self, "OnEnemyRemoved"))
		#EnemyInstance.connect()

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
	
func OnEnemyRemoved(enemy):
	Enemies.erase(enemy)
