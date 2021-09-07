extends "res://Artifacts/Artifact.gd"

func _ready() -> void:
	spaceship.get_node("Sprite").add_child(preload("res://Spaceship/AutomaticTurret.tscn").instance())
