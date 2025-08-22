extends state_machine_base
class_name npc_state_machine

enum _states{
	Idle, 
	Run
	}

func _ready() -> void:
	InitState(_states.Idle)

func _physics_process(delta: float) -> void:	
	match _current_state:
		_states.Idle:
			IdleState()
		_states.Run:
			RunState()

func IdleState():
	_animation_player.play("idle")
	if _parent._direction != Vector2.ZERO:
		StateTransition(_states.Run)

func RunState():
	_animation_player.play("run")
	if _parent._direction == Vector2.ZERO:
		StateTransition(_states.Idle)
