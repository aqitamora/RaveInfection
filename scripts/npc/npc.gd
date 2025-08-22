extends CharacterBase

var _state : int = 0

@onready var _direction_timer : Timer = $DirectionTimer

func _ready() -> void:
	_speed = 20.0
func _physics_process(delta: float) -> void:

	velocity = lerp(velocity, _direction * _speed, delta * _speed/10)
	move_and_slide()

func _on_direction_timer_timeout() -> void:

	randomize()
	_state = randi_range(0,1)
	match _state:
		0:
			_state_machine.StateTransition(_state_machine._states.Idle)
			_direction = Vector2.ZERO
		1:
			_state_machine.StateTransition(_state_machine._states.Run)
			randomize()
			_direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	SpriteFlip()
	
	_direction_timer.start()
