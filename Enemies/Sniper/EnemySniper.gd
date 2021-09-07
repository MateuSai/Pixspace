extends "res://Enemies/Enemy.gd"

onready var canon: Position2D = get_node("Canon")

func _physics_process(delta: float) -> void:
	if position.y <= 0 + ship_height/2 + 2:
		position.y += front_speed * delta


func take_damage(dam: int) -> void:
	hp -= dam
	if hp <= 0:
		_spawn_explosion()
		_spawn_scrap((randi() % 2) + 2)
		queue_free()


func _on_ShootTimer_timeout() -> void:
	_spawn_projectile(canon.global_position)
