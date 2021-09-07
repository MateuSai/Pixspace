extends CanvasLayer

const ARTIFACT_DISPLAY_PATH: PackedScene = preload("res://Artifacts/ArtifactDisplay.tscn")

signal artifact_collected(name)

onready var artifactContainer: HBoxContainer = get_node("CenterContainer/HBoxContainer")
onready var fadeTween: Tween = get_node("CenterContainer/FadeTween")
onready var moveTween: Tween = get_node("CenterContainer/MoveTween")

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _ready() -> void:
	# Create an array of possible artifact indexes excluding the artifacts arleady owned
	var possible_artifacts_index: Array = []
	for i in Data.artifacts.all.size():
		# If the artifact is not available, continue to the next index
		if not Data.artifacts.get_index(i).available:
			continue
		var is_artifact_owned: bool = false
		for artifact_owned_name in PlayerStats.stats.artifacts:
			if artifact_owned_name == Data.artifacts.get_index(i).name:
				is_artifact_owned = true
				break
		if not is_artifact_owned:
			possible_artifacts_index.append(i)
	var artifacts_to_display: Array = _random_artifacts(possible_artifacts_index)
	
	# Spawn the artifacts
	for i in artifacts_to_display:
		var artifact = Data.artifacts.get_index(i)
		var ArtifactDisplay: VBoxContainer = ARTIFACT_DISPLAY_PATH.instance()
		ArtifactDisplay.name = artifact.name
		ArtifactDisplay.get_node("Button/TextureRect").texture = load(artifact.icon)
		ArtifactDisplay.get_node("Panel/NameLabel").text = artifact.name
		ArtifactDisplay.get_node("Panel/DescriptionLabel").text = artifact.description
		artifactContainer.add_child(ArtifactDisplay)
		ArtifactDisplay.connect("artifact_selected", self, "_on_artifact_pressed")
		
		
func _random_artifacts(artifacts_array: Array) -> Array:
	# Return 3 random artifacts indexes
	var random_artifacts: Array = []
	for i in 3:
		if artifacts_array.size() > 0:
			var rand: int = artifacts_array[randi() % artifacts_array.size()]
			random_artifacts.append(rand)
			artifacts_array.erase(rand)
		else:
			break
	return random_artifacts


func _on_artifact_pressed(artifact_name: String) -> void:
	_select_artifact(artifact_name)
	
	
func _select_artifact(artifact_name: String) -> void:
	_disable_buttons()
	_fade_artifacts()
	_collect_artifact(artifact_name)
	
	
func _disable_buttons() -> void:
	for artifact in artifactContainer.get_children():
		artifact.get_node("Button").disabled = true
	
	
func _fade_artifacts() -> void:
	for artifact in artifactContainer.get_children():
		fadeTween.interpolate_property(artifact, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6)
	fadeTween.start()
	
	
func _collect_artifact(artifact_name: String) -> void:
	var artifact: VBoxContainer = artifactContainer.get_node(artifact_name)
	var artifactSprite: Sprite = Sprite.new()
	artifactSprite.texture = artifact.get_node("Button/TextureRect").texture
	artifactSprite.position = artifact.get_node("Button/TextureRect").rect_global_position
	moveTween.interpolate_property(artifactSprite, "position", artifactSprite.position,
								   get_parent().get_node("Spaceship").global_position, 0.7)
	moveTween.interpolate_property(artifactSprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.7,
								   Tween.TRANS_SINE, Tween.EASE_IN)
	add_child(artifactSprite)
	moveTween.start()
	
	yield(moveTween, "tween_completed")
	
	artifactSprite.queue_free()
	emit_signal("artifact_collected", artifact_name)


func _on_FadeTween_tween_completed(_object: Object, _key: NodePath) -> void:
	for artifact in artifactContainer.get_children():
		artifact.queue_free()
