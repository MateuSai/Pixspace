extends "res://Enemies/Enemy.gd"

const FRICTION: float = 0.1

var accerelation: int = 20
var max_speed_x: int = 30
var velocity_x: float = 0.0

onready var leftCanon: Position2D = get_node("Canons/LeftCanon")
onready var rightCanon: Position2D = get_node("Canons/RightCanon")
onready var player: KinematicBody2D = get_parent().get_parent().get_node("Spaceship")

func _physics_process(delta: float) -> void:
	var direction: float = (player.position - position).normalized().x
	sprite.material.set_shader_param("curvature", direction)
	position.y += front_speed * delta
	velocity_x = clamp(velocity_x + accerelation * direction, -max_speed_x, max_speed_x)
	position.x += velocity_x * delta
	velocity_x = lerp(velocity_x, 0.0, FRICTION)


func take_damage(dam: int) -> void:
	hp -= dam
	if hp <= 0:
		_spawn_explosion()
		_spawn_scrap((randi() % 3) + 2)
		queue_free()


func _on_ShootTimer_timeout() -> void:
	_spawn_projectile(leftCanon.global_position, 1)
	_spawn_projectile(rightCanon.global_position, -1)
