extends "res://LevelScene.gd"

func _ready() -> void:
	_enter_level(1, 0.3, false)


func _on_ArtifactsExpositor_artifact_collected(_name: String) -> void:
	_exit_level()
	SceneChanger.change_scene("res://Game.tscn")
