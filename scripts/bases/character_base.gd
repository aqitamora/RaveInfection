extends CharacterBody2D
class_name CharacterBase

@export var _speed : float = 30.0

var _direction : Vector2
@onready var _sprite : Sprite2D = $Sprite2D
@onready var _state_machine : state_machine_base = $State_Machine

func SpriteFlip() -> void:
	if _direction.x < 0:
		_sprite.flip_h = true
	elif _direction.x > 0:
		_sprite.flip_h = false
