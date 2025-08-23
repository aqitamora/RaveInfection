extends CharacterBody2D

@onready var _normal_sprite : Sprite2D = $NormalTexture
@onready var _damaged_sprite : Sprite2D = $DamagedTexture
@onready var _explPart : GPUParticles2D = $ExplParticle
func _ready() -> void:
	_normal_sprite.show()

func DamagedEnviroument():
	Singleton._player.Screen_shake(3,1)
	_explPart.emitting = true
	remove_from_group("enviroument")
	add_to_group("damaged_enviroument")
	_normal_sprite.hide()
	_damaged_sprite.show()
