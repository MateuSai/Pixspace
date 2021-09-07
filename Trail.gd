extends Line2D
class_name Trail

export(int) var trail_length: int = 10

onready var parent: Node2D = get_parent()

func _process(_delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	add_point(parent.position)
	if get_point_count() > trail_length:
		remove_point(0)
