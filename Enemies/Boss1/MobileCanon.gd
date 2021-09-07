extends Sprite

const PROJECTILE: PackedScene = preload("res://Projectiles/EnemyProjectile.tscn")

export(int) var projectile_speed: int = 50
var direction: Vector2 = Vector2.ZERO

onready var spaceship: KinematicBody2D = get_parent().get_parent().get_parent().get_node("Spaceship")
onready var leftCanon: Position2D = get_node("LeftCanon")
onready var rightCanon: Position2D = get_node("RightCanon")

func _process(_delta: float) -> void:
	if spaceship != null:
		direction = (spaceship.position - global_position).normalized()
		rotation = direction.angle() - PI/2


func _on_Timer_timeout() -> void:
	var bursts: int = 0
	while bursts < 3:
		_spawn_projectile(leftCanon.global_position)
		_spawn_projectile(rightCanon.global_position)
		bursts += 1
		yield(get_tree().create_timer(0.15), "timeout")
	
	
func _spawn_projectile(pos: Vector2) -> void:
	var Projectile: Area2D = PROJECTILE.instance()
	Projectile.position = pos
	Projectile.direction = direction
	Projectile.speed = projectile_speed
	Projectile.rotation = direction.angle() - PI/2
	get_parent().get_parent().get_parent().add_child(Projectile)
