extends Node2D

func _on_Play_pressed() -> void:
	SceneChanger.change_scene("res://Game.tscn", 0)


func _on_Quit_pressed() -> void:
	get_tree().quit()
