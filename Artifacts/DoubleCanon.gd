extends "res://Artifacts/Artifact.gd"

func _ready() -> void:
	spaceship.double_canon = true
	spaceship.get_node("Sprite/DoubleCanon").visible = true
