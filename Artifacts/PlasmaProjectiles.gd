extends "res://Artifacts/Artifact.gd"

func _ready() -> void:
	spaceship.projectile_damage += 2
	spaceship.plasma_projectiles = true

