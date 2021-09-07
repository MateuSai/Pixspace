extends CanvasLayer

onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")

func change_scene(new_scene_path: String, initial_delay: float = 0.5) -> void:
	yield(get_tree().create_timer(initial_delay), "timeout")
	animationPlayer.play("fade")
	yield(animationPlayer, "animation_finished")
	assert(get_tree().change_scene(new_scene_path) == OK)
	yield(get_tree().create_timer(1), "timeout")
	animationPlayer.play_backwards("fade")
