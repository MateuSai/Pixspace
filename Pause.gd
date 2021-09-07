extends CanvasLayer

var is_paused: bool = false setget set_is_paused

onready var spaceship: KinematicBody2D = get_parent().get_node("Spaceship")
onready var colorRect: ColorRect = get_node("ColorRect")
onready var vBoxContainer: VBoxContainer = get_node("VBoxContainer")
onready var artifactsContainer: GridContainer = get_node("VBoxContainer/VBoxContainer/PanelContainer/Artifacts")
onready var descriptionLabel: Label = get_node("VBoxContainer/VBoxContainer/ArtifactDescription/Label")

func _ready() -> void:
	_spawn_artifacts()
	vBoxContainer.visible = false
	descriptionLabel.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.is_paused = not is_paused
		
		
func _process(_delta: float) -> void:
	var artifact_selected: TextureRect = _artifact_selected()
	if artifact_selected != null and is_paused:
		descriptionLabel.text = spaceship.get_node("Artifacts").get_node(artifact_selected.name).description
		descriptionLabel.visible = true
	else:
		descriptionLabel.visible = false
	
	
func _artifact_selected() -> TextureRect:
	for artifact in artifactsContainer.get_children():
		if artifact.get_global_rect().has_point(get_viewport().get_mouse_position()):
			return artifact
	return null
		
		
func _spawn_artifacts() -> void:
	for artifact in spaceship.get_node("Artifacts").get_children():
		var artifact_sprite: TextureRect = TextureRect.new()
		artifact_sprite.name = artifact.name
		artifact_sprite.texture = artifact.icon
		artifactsContainer.add_child(artifact_sprite)


func set_is_paused(new_value: bool) -> void:
	is_paused = new_value
	get_tree().paused = is_paused
	vBoxContainer.visible = is_paused
	if is_paused:
		colorRect.color.a = 0.4
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		colorRect.color.a = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		
func _on_Continue_pressed() -> void:
	self.is_paused = false


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_TouchScreenButton_pressed() -> void:
	self.is_paused = true
