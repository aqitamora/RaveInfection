extends CharacterBase

func _physics_process(delta: float) -> void:
	GetInput()

	velocity = lerp(velocity, _direction * _speed, delta * _speed/10)
	move_and_slide()

func GetInput():
	_direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down")).normalized()

	SpriteFlip()

	return _direction
