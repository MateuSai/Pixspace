extends Node2D

func _on_Play_pressed() -> void:
	PlayerStats.stats = {
	"stage": 1,
	"scrap": 0,
	"hp": -1,
	"artifacts": []
}
	SceneChanger.change_scene("res://Game.tscn", 0)


func _on_Quit_pressed() -> void:
	get_tree().quit()
