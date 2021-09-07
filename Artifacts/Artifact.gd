extends Node
class_name Artifact

var icon: Texture = null
var description: String = ""

onready var spaceship: KinematicBody2D = get_parent().get_parent()

func _enter_tree() -> void:
	icon = load(Data.artifacts.get(name).icon)
	description = Data.artifacts.get(name).description
