extends VBoxContainer

signal artifact_selected(artifact_name)

func _on_Button_pressed() -> void:
	emit_signal("artifact_selected", name)
