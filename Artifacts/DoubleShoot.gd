extends "res://Artifacts/Artifact.gd"

func _ready() -> void:
	spaceship.double_shoot = true
	spaceship.projectile_damage -= 1
