extends state_machine_base
class_name npc_state_machine




enum _states{
	Idle, 
	Run,
	InfectedIdle,
	InfectedFollowing,
	InfectedChase
	}

func _ready() -> void:
	InitState(_states.Idle)

func _physics_process(_delta: float) -> void:
	
	match _current_state:
		_states.Idle:
			IdleState()
		_states.Run:
			RunState()
		_states.InfectedFollowing:
			InfectedFollowing()
		_states.InfectedIdle:
			InfectedIdle()
		_states.InfectedChase:
			InfectedChase()

func IdleState():
	_animation_player.play("idle")
	if _parent._direction != Vector2.ZERO:
		StateTransition(_states.Run)

func RunState():
	_animation_player.play("run")
	if _parent._direction == Vector2.ZERO:
		StateTransition(_states.Idle)

func InfectedIdle():
	_parent._direction = Vector2.ZERO
	_animation_player.play("idle")
	if _parent._target:
		if _parent.global_position.distance_to(_parent._target.global_position) > 30.0:
			StateTransition(_states.InfectedFollowing)

func InfectedFollowing():
	_animation_player.play("run")
	var _target_pos =  _parent._target.global_position + _parent._personal_offset
	_parent._direction = (_target_pos - _parent.global_position).normalized()

	if _parent._target:
		if _parent.global_position.distance_to(_parent._target.global_position) < 30.0:
			StateTransition(_states.InfectedIdle)

func InfectedChase():
	_animation_player.play("run")
	if _parent._target.is_in_group("NPC") or _parent._target.is_in_group("enviroument"):
		_parent._direction = (_parent._target.global_position - _parent.global_position).normalized()
	else:
		_parent._direction = (_parent._direction - _parent._target.global_position).normalized()
		await get_tree().create_timer(2.0).timeout
		StateTransition(_states.InfectedIdle)
		_parent._target = _parent._player_target
