extends Node2D

onready var background: TextureRect = get_node("Background")
onready var spaceship: KinematicBody2D = get_node("Spaceship")
onready var spaceshipMoveTeen: Tween = get_node("Spaceship/MoveTween")
onready var velocityParticles: Particles2D = get_node("VelocityParticles")

func _enter_level(initial_delay: float = 0.2, final_background_speed: float = 0.4,
				  recover_control: bool = true) -> void:
	velocityParticles.emitting = true
	_desactivate_ship()
	spaceship.position = Vector2(Utils.SCREEN_WIDTH/2, Utils.SCREEN_HEIGHT + 10)
	spaceshipMoveTeen.interpolate_property(spaceship, "position", spaceship.position,
										   Vector2(Utils.SCREEN_WIDTH/2, Utils.SCREEN_HEIGHT * 0.7), 1,
										   Tween.TRANS_CUBIC, Tween.EASE_OUT)
	yield(get_tree().create_timer(initial_delay), "timeout")
	spaceshipMoveTeen.start()
	
	yield(spaceshipMoveTeen, "tween_completed")
	
	background.material.set_shader_param("scroll_speed", final_background_speed)
	velocityParticles.emitting = false
	
	if recover_control:
		yield(get_tree().create_timer(0.5), "timeout")
		_activate_ship()
		
		
func _ready() -> void:
	if PlayerStats.stats.stage > 4:
		background.texture = preload("res://Space_Stars6.png")
		
		
func _exit_level() -> void:
	PlayerStats.stats.hp = spaceship.hp
	velocityParticles.emitting = true
	background.material.set_shader_param("scroll_speed", 1.5)
	_desactivate_ship()
	spaceshipMoveTeen.interpolate_property(spaceship, "position", spaceship.position,
										   Vector2(spaceship.position.x, -10), 1.5, Tween.TRANS_CUBIC,
										   Tween.EASE_IN)
	spaceshipMoveTeen.start()


func _desactivate_ship() -> void:
	spaceship.can_move = false
	spaceship.is_shooting = false
	
	
func _activate_ship() -> void:
	spaceship.can_move = true
	spaceship.is_shooting = true
