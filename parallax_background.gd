extends ParallaxBackground

func _ready():
	get_tree().get_root().size_changed.connect(_update_parallax)
	_update_parallax()
var speed = 10
@export var layer_speeds: Array[Vector2] = [
	Vector2(10, 5),    # Слой 0 - медленно
	Vector2(30, 15),  
	Vector2(30, 15), 
	Vector2(30, 15),  # Слой 1 - средняя скорость
	Vector2(50, 25)    # Слой 2 - быстро
]
func _process(delta: float) -> void:
	pass
	##scroll_offset.x -= speed * delta
	#for i in range(get_child_count()):
		#var layer = get_child(i)
		#if layer is ParallaxLayer:
			## Увеличиваем смещение на скорость с учетом времени
			#layer.motion_offset.x -= layer_speeds[i].x * delta
			#
			## Автоматически сбрасываем offset для бесшовной прокрутки
			#var texture_size = get_viewport().get_visible_rect().size # Укажите размер вашей текстуры
			#if layer.motion_offset.x > texture_size.x:
				#layer.motion_offset.x = 0

func _update_parallax():
	var viewport_size = get_viewport().get_visible_rect().size
	for child in get_children():
		if child is ParallaxLayer:
			var texture_size = child.get_node("Sprite2D").texture.get_size()
			
			# Масштабируем спрайт чтобы покрыть весь экран
			var scale = max(
				viewport_size.x / texture_size.x,
				viewport_size.y / texture_size.y
			) * 1.1  # Небольшой запас для движения
			
			child.get_node("Sprite2D").scale = Vector2(scale, scale)
			child.motion_mirroring = Vector2(
				texture_size.x * scale,
				texture_size.y * scale
			)
