extends "res://Enemies/Enemy.gd"

const WAVE_PROJECTILE: PackedScene = preload("res://Projectiles/WaveProjectile.tscn")
const REWARD_ARTIFACT_NAME: String = "AutomaticTurret"

onready var spaceship: KinematicBody2D = get_parent().get_parent().get_node("Spaceship")

onready var moveTween: Tween = get_node("MoveTween")

onready var leftCanon: Position2D = get_node("Canons/LeftCanon")
onready var rightCanon: Position2D = get_node("Canons/RightCanon")
onready var leftWaveCanon: Position2D = get_node("Canons/LeftWaveCanon")
onready var rightWaveCanon: Position2D = get_node("Canons/RightWaveCanon")

onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")

onready var shootTimer: Timer = get_node("ShootTimer")
onready var shootWaveTimer: Timer = get_node("ShootWaveTimer")

func _ready() -> void:
	moveTween.interpolate_property(self, "position", Vector2(position.x, -ship_height/2),
								   Vector2(position.x, ship_height/2), 1)
	moveTween.start()


func take_damage(dam: int) -> void:
	hp -= dam
	animationPlayer.play("flash")
	if hp <= 0:
		_spawn_multiple_explosions()
		yield(get_tree().create_timer(0.5), "timeout")
		_spawn_scrap((randi() % 8) + 10)
		get_parent().get_parent().give_artifact(REWARD_ARTIFACT_NAME, position)
		queue_free()


func _on_ShootTimer_timeout() -> void:
	_spawn_projectile(leftCanon.global_position)
	_spawn_projectile(rightCanon.global_position)


func _on_ShootWaveTimer_timeout() -> void:
	_spawn_projectile(leftWaveCanon.global_position, 0, WAVE_PROJECTILE)
	_spawn_projectile(rightWaveCanon.global_position, 0, WAVE_PROJECTILE)


func _on_MoveTween_tween_completed(_object: Object, _key: NodePath):
	shootTimer.start()
	shootWaveTimer.start()
