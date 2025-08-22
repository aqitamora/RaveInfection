extends Node
class_name state_machine_base


var _current_state

@onready var _animation_player = $"../AnimationPlayer"
@onready var _parent = $".."

func InitState(_init_state):
	_current_state = _init_state

func StateTransition(_new_state):
	if _new_state != _current_state:
		_current_state = _new_state
