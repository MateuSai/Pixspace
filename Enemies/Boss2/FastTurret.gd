extends Sprite

const PROJECTILE: PackedScene = preload("res://Projectiles/BigLargeProjectile.tscn")

export(int) var projectile_speed: int = 50
var direction: Vector2 = Vector2.ZERO

onready var spaceship: KinematicBody2D = get_parent().get_parent().get_parent().get_node("Spaceship")
onready var canon: Position2D = get_node("Canon")
onready var chargeParticles: Particles2D = get_node("ChargeParticles")

onready var chargeTimer: Timer = get_node("ChargeTimer")
onready var shootDelayTimer: Timer = get_node("ShootDelayTimer")

func _ready() -> void:
	yield(get_tree().create_timer(1), "timeout")
	chargeParticles.emitting = true
	chargeTimer.start()


func _process(_delta: float) -> void:
	if spaceship != null:
		direction = (spaceship.position - global_position).normalized()
		rotation = direction.angle() - PI/2
	
	
func _spawn_projectile(pos: Vector2) -> void:
	var Projectile: Area2D = PROJECTILE.instance()
	Projectile.position = pos
	Projectile.direction = direction
	Projectile.speed = projectile_speed
	Projectile.rotation = direction.angle() - PI/2
	get_parent().get_parent().get_parent().add_child(Projectile)


func _on_ChargeTimer_timeout() -> void:
	chargeParticles.emitting = false
	_spawn_projectile(canon.global_position)
	shootDelayTimer.start()


func _on_ShootDelayTimer_timeout() -> void:
	chargeParticles.emitting = true
	chargeTimer.start()
