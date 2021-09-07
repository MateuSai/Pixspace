extends Particles2D

func _ready() -> void:
	emitting = true
	one_shot = true
	for child in get_children():
		if child is Particles2D:
			child.emitting = true
			child.one_shot = true
		if child is AudioStreamPlayer:
			child.play()
	
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
