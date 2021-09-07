extends Area2D

const EXPLOSION_PATH: PackedScene = preload("res://Particles/LittleExplosion.tscn")

var damage: int = 2

var time: float = 0.0
var initial_fase: float = 0.0
var initial_position: float = 0.0
var speed_y: int = 80
var frequency: float = 0.5
var angular_frequency: float = 2 * PI * frequency
var direction: int = 0
var amplitude: int = 9

onready var sprite: Sprite = get_node("Sprite")

func _enter_tree() -> void:
	initial_position = position.x
	initial_fase = asin((position.x - initial_position) / amplitude)
	
	if direction == 0:
		if randi() % 2 == 0:
			angular_frequency *= -1
	else:
		angular_frequency *= direction


func _physics_process(delta: float) -> void:
	time += delta
	position.y += speed_y * delta
	position.x = initial_position + amplitude * sin(angular_frequency * time + initial_fase)
	
	
func _spawn_explosion() -> void:
	var Explosion: Particles2D = EXPLOSION_PATH.instance()
	Explosion.position = global_position
	Explosion.modulate = sprite.modulate
	get_parent().add_child(Explosion)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_DronProjectile_body_entered(body: Node) -> void:
	body.take_damage(damage)
	_spawn_explosion()
	queue_free()


func _on_DronProjectile_area_entered(area: Area2D) -> void:
	area.take_damage(damage)
	_spawn_explosion()
	queue_free()
