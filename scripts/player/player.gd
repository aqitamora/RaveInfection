extends CharacterBase

@warning_ignore("unused_private_class_variable")
@onready var _camera : Camera2D = $Camera2D_ScreenShake

func _physics_process(delta: float) -> void:
	GetInput()

	velocity = lerp(velocity, _direction * _speed, delta * _speed/10)
	move_and_slide()

func GetInput():
	_direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down")).normalized()

	SpriteFlip()

	return _direction


func _on_infection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("NPC"):
		body.Infected.emit()
