extends Area2D

export(PackedScene) var explosion_path: PackedScene = preload("res://Particles/LittleExplosion.tscn")

export(int) var damage: int = 1
export(Vector2) var direction: Vector2 = Vector2.ZERO
export(int) var speed: int = 35

onready var sprite: Sprite = get_node("Sprite")
onready var light2D: Light2D = get_node("Light2D")

func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_Projectile_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
	_spawn_explosion()
	queue_free()
	
	
func _on_Projectile_area_entered(area: Area2D) -> void:
	area.take_damage(damage)
	_spawn_explosion()
	queue_free()
	

func _spawn_explosion() -> void:
	var Explosion: Particles2D = explosion_path.instance()
	Explosion.position = global_position
	Explosion.modulate = sprite.modulate
	get_parent().add_child(Explosion)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
