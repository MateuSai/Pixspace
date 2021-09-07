extends "res://Artifacts/Artifact.gd"

func _ready() -> void:
	spaceship.get_node("EnergyShield").max_shield_points += 3
	spaceship.get_node("EnergyShield").recovering_speed -= 0.3
	spaceship.get_node("EnergyShield").recoverTimer.wait_time -= 0.7
	spaceship.get_node("EnergyShield").sprite.texture = preload("res://Spaceship/Improved Energy Shield.pxo")
