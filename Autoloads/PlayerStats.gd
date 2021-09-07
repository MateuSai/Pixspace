extends Node

var stats: Dictionary = {
	"stage": 1,
	"scrap": 0,
	"hp": -1,
	"artifacts": []
}

func add_artifact(artifact_name: String) -> void:
	stats.artifacts.append(artifact_name)
	
	
func load_artifacts() -> Array:
	var artifacts: Array = []
	for artifact_name in stats.artifacts:
		var Artifact: Node = load("res://Artifacts/" + artifact_name + ".tscn").instance()
		artifacts.append(Artifact)
	return artifacts

