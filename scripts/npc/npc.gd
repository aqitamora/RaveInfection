extends CharacterBase

signal Infected

var _state : int = 0
var _infected : bool = false

@onready var _explPart : GPUParticles2D = $ExplParticle
@onready var _direction_timer : Timer = $Direction_Timer
@onready var _evade_infect_area : Area2D = $Evade_Infect_Area
@onready var _target
@onready var _player_target = get_tree().get_first_node_in_group("player")

@onready var _chase_area: Area2D = $Chasing_Area
@onready var _infection_area: Area2D = $Infection_Area
var _personal_offset : Vector2

func _ready() -> void:
	_speed = 15.0
	Infected.connect(OnInfect)
	
func _physics_process(delta: float) -> void:
	SpriteFlip()
	velocity = lerp(velocity, _direction * _speed, delta * _speed/10)
	move_and_slide()
	#print(_state_machine._current_state)


#UnInfected
func _on_direction_timer_timeout() -> void:
	if !_infected:
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
	
		_direction_timer.start()


func _on_evade_area_body_entered(body: Node2D) -> void:
	if !_infected:
		if body.is_in_group("player") or body.is_in_group("infected"):
			
			_speed = 25.0
			_direction = (global_position - body.global_position).normalized()
			_direction_timer.stop()


func _on_evade_area_body_exited(body: Node2D) -> void:
	if !_infected:
		if body.is_in_group("player") or body.is_in_group("infected"):
			
			_speed = 15.0
			_direction = Vector2.ZERO
			_state_machine.StateTransition(_state_machine._states.Idle)
			
			_direction_timer.start()
	
#UnInfected


#Infected
func OnInfect():
	_explPart.emitting = true
	var angle = randf() * TAU  # Случайный угол
	var radius = 25.0  # Радиус окружения
	_personal_offset = Vector2(cos(angle), sin(angle)) * radius
	
	_target = _player_target
	_infected = true
	_evade_infect_area.monitoring = false
	_infection_area.monitoring = true
	_chase_area.monitoring = true
	
	_state_machine.StateTransition(_state_machine._states.InfectedIdle)
	_speed = 28.0
	_direction = Vector2.ZERO
	
	remove_from_group("NPC")
	add_to_group("infected")
	
	_sprite.modulate = ("648759")


func _on_chasing_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("NPC") or body.is_in_group("enviroument") or body.is_in_group("police"):
		_target = body
		_state_machine.StateTransition(_state_machine._states.InfectedChase)
	

func _on_infection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("NPC"):
		body.Infected.emit()
		_target = _player_target
		_state_machine.StateTransition(_state_machine._states.InfectedIdle)
	elif body.is_in_group("enviroument"):
		body.DamagedEnviroument()
		_target = _player_target
		_state_machine.StateTransition(_state_machine._states.InfectedIdle)
