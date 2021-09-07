extends Area2D
class_name Hitbox

export(int) var mele_damage: int = 2

onready var parent: KinematicBody2D = get_parent()

func _init() -> void:
	connect("body_entered", self, "_on_body_entered")
	
	
func _on_body_entered(body: Node) -> void:
	body.take_damage(1000)
	parent.take_damage(mele_damage)
