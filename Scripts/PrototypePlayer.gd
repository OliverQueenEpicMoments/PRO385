extends CharacterBody2D


@export var Speed = 100.0
@export var Acceleration = 10.0

func	_physics_process(delta: float) -> void:
	var Direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	velocity.x = move_toward(velocity.x, Speed * Direction.x, Acceleration)
	velocity.y = move_toward(velocity.y, Speed * Direction.y, Acceleration)

	move_and_slide()
