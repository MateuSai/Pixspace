extends KinematicBody2D

export(PackedScene) var projectile_path = null
const SCRAP_PATH: PackedScene = preload("res://Scrap/Scrap.tscn")

export(int) var hp: int = 1
export(int) var front_speed: int = 15

onready var sprite: Sprite = get_node("Sprite")
onready var ship_width: int = sprite.texture.get_size().x
onready var ship_height: int = sprite.texture.get_size().y

func _process(_delta: float) -> void:
	if position.y >= Utils.SCREEN_HEIGHT + ship_height + 30:
		queue_free()


func _spawn_projectile(pos: Vector2, dir: int = 0, projectile: PackedScene = projectile_path) -> void:
	var Projectile: Area2D = projectile.instance()
	Projectile.position = pos
	if dir != 0:
		Projectile.direction = dir
	get_parent().get_parent().add_child(Projectile)


func _spawn_scrap(num: int) -> void:
	for i in num:
		var Scrap: KinematicBody2D = SCRAP_PATH.instance()
		Scrap.position = global_position
		get_parent().get_parent().call_deferred("add_child", Scrap)
		
		
func _spawn_explosion(pos: Vector2 = global_position) -> void:
	var explosion: PackedScene = preload("res://Particles/MediumExplosion.tscn")
	var Explosion: Particles2D = explosion.instance()
	Explosion.position = pos
	get_parent().get_parent().add_child(Explosion)
	
	
func _spawn_multiple_explosions() -> void:
	for i in randi() % 10 + 10:
		var rand_pos: Vector2 = Vector2(rand_range(global_position.x - ship_width/2,
										global_position.x + ship_width/2), rand_range(global_position.y
										- ship_height/2, global_position.y + ship_height/2))
		_spawn_explosion(rand_pos)

