extends "res://Artifacts/Artifact.gd"

func _ready() -> void:
	spaceship.projectile_damage += 1
	spaceship.projectile_speed += 10
	spaceship.projectile_scene = preload("res://Projectiles/LargePlayerProjectile.tscn")

