extends Sprite

var projectile_scene: PackedScene = null

var enemies_in_range: Array = []
var there_is_enemy_in_range: bool = false

var plasma_projectiles: bool = false
var projectile_damage: int = 0
var projectile_speed: int = 0
var double_shoot: bool = false

var direction: Vector2 = Vector2.ZERO

onready var spaceship: KinematicBody2D = get_parent().get_parent()
onready var canonSprite: Sprite = get_node("CanonSprite")
onready var canon: Position2D = get_node("CanonSprite/Position2D")
onready var shootTimer: Timer = get_node("Timer")

func _ready() -> void:
	spaceship.connect("ready", self, "_on_Spaceship_ready")
	spaceship.connect("double_shoot_changed", self, "_on_Spaceship_double_shoot_changed")
	spaceship.connect("plasma_projectiles_changed", self, "_on_Spaceship_plasma_projectiles_changed")


func _on_Spaceship_ready() -> void:
	projectile_scene = spaceship.projectile_scene
	projectile_damage = spaceship.projectile_damage - 1
	projectile_speed = spaceship.projectile_speed - 10
	
	_on_Spaceship_double_shoot_changed(spaceship.double_shoot)
	_on_Spaceship_plasma_projectiles_changed(spaceship.plasma_projectiles)
	
	
func _on_Spaceship_double_shoot_changed(new_value: bool) -> void:
	double_shoot = new_value
	if double_shoot:
		canonSprite.texture = preload("res://Spaceship/Automatic Turret Double Canon.pxo")
		canonSprite.offset = Vector2.ZERO
		
		
func _on_Spaceship_plasma_projectiles_changed(new_value: bool) -> void:
	plasma_projectiles = new_value


func _process(_delta: float) -> void:
	var nearest_enemy: Node2D = _get_nearest_enemy(enemies_in_range)
	if nearest_enemy != null:
		if not there_is_enemy_in_range:
			there_is_enemy_in_range = true
			shootTimer.start()
		direction = (nearest_enemy.position - spaceship.position).normalized()
		canonSprite.rotation = lerp(canonSprite.rotation, direction.angle() + PI/2, 0.3)
	else:
		if there_is_enemy_in_range:
			there_is_enemy_in_range = false
			shootTimer.stop()
		canonSprite.rotation = lerp(canonSprite.rotation, 0, 0.3)


func _on_EnemyDetector_body_entered(body: Node) -> void:
	enemies_in_range.append(body)


func _on_EnemyDetector_body_exited(body: Node) -> void:
	enemies_in_range.erase(body)


func _on_Timer_timeout() -> void:
	# Spawn projectile
	if double_shoot:
		_spawn_projectile(canon.global_position + Vector2.LEFT, direction)
		_spawn_projectile(canon.global_position + Vector2.RIGHT, direction)
	else:
		_spawn_projectile(canon.global_position, direction)
	
	
func _get_nearest_enemy(enemies_array: Array) -> Node2D:
	var nearest_enemy: Node2D = null
	var shortest_distance: float = 10000
	for enemy in enemies_array:
		if enemy == null:
			enemies_in_range.erase(enemy)
			continue
		var distance: float = (enemy.position - spaceship.position).length()
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_enemy = enemy
	return nearest_enemy
	
	
func _spawn_projectile(pos: Vector2, dir: Vector2) -> void:
	# Spawn a projectile
	var Projectile: Area2D = projectile_scene.instance()
	Projectile.position = pos
	Projectile.direction = dir
	Projectile.get_node("Sprite").rotation = direction.angle() + PI/2
	if plasma_projectiles:
		Projectile.get_node("Sprite").modulate = Color(0.2, 0.7, 0.8)
		Projectile.get_node("Light2D").modulate = Color(0.2, 0.7, 0.8)
	Projectile.damage = projectile_damage
	Projectile.speed = projectile_speed
	spaceship.get_parent().add_child(Projectile)


func _on_Spaceship_projectile_damage_changed(new_value: int) -> void:
	projectile_damage = new_value - 1


func _on_Spaceship_projectile_speed_changed(new_value: int) -> void:
	projectile_speed = new_value - 10
