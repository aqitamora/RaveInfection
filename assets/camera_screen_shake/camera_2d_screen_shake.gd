extends Camera2D

var _shake_intensivity: float = 0.0
var _active_shake_time: float = 0.0

var _shake_dekay: float = 5.0

var _shake_time: float = 0.0
var _shake_time_speed: float = 20.0

var _noise = FastNoiseLite.new()

func _physics_process(delta: float) -> void:
	if _active_shake_time > 0:
		_shake_time += delta * _shake_time_speed
		_active_shake_time -= delta
		
		offset = Vector2(
			_noise.get_noise_2d(_shake_time, 0) * _shake_intensivity,
			_noise.get_noise_2d(0, _shake_time) * _shake_intensivity 
		)
		
		_shake_intensivity = max(_shake_intensivity - _shake_dekay * delta, 0)
	else:
		offset = lerp(offset,Vector2.ZERO, 10.5 * delta)	
	
func Screen_shake(_intensity: int, _time: float):
	randomize()
	_noise.seed = randi()
	_noise.frequency = 2.0
	
	_shake_intensivity = _intensity
	_active_shake_time = _time
	
	_shake_time = 0.0
