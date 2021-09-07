extends KinematicBody2D

const DEAD_PARTICLES_SCENE: PackedScene = preload("res://Particles/SpaceshipExplosion.tscn")
signal destroyed()

var projectile_scene: PackedScene = preload("res://Projectiles/PlayerProjectile.tscn")

var hp: int = 0 setget set_hp
signal hp_changed(previous_hp, new_hp)
var max_hp: int = 3

export(float) var shoot_delay = 0.8 setget set_shoot_delay

var plasma_projectiles: bool = false setget set_plasma_projectiles
signal plasma_projectiles_changed(new_value)
export(int) var projectile_damage: int = 3 setget set_projectile_damage
signal projectile_damage_changed(new_value)
var projectile_speed: int = 60 setget set_projectile_speed
signal projectile_speed_changed(new_value)

var can_move: bool = true
var is_shooting: bool = true

var curvature: float = 0.0 setget set_curvature

# Engine particles variables
var previous_engine_state: int = NORMAL
var engine_state: int = NORMAL
enum {LOW, NORMAL, HIGH}
const ENGINE_PARTICLES_SCALES: PoolVector2Array = PoolVector2Array([
	Vector2(0.6, 0.5),
	Vector2(1, 1),
	Vector2(1.2, 1.4)
	])
	
var double_canon: bool = false
var double_shoot: bool = false setget set_double_shoot
signal double_shoot_changed(new_value)

onready var sprite: Sprite = get_node("Sprite")

onready var middleCanon: Position2D = get_node("Canons/MiddleCanon")
onready var leftCanon: Position2D = get_node("Canons/LeftCanon")
onready var rightCanon: Position2D = get_node("Canons/RightCanon")

onready var engineParticles: Particles2D = get_node("Particles2D")
onready var engineParticlesTween: Tween = get_node("Particles2D/Tween")

onready var shootTimer: Timer = get_node("ShootTimer")
onready var shootSound: AudioStreamPlayer = get_node("ShootSound")

onready var collectArtifactSound: AudioStreamPlayer = get_node("CollectArtifactSound")

onready var UI: CanvasLayer = get_node("UI")

onready var energyShield: Area2D = get_node("EnergyShield")

onready var artifactContainer: Node = get_node("Artifacts")

func _ready() -> void:
	# Load artifacts
	for artifact in PlayerStats.load_artifacts():
		artifactContainer.add_child(artifact)
		
	if PlayerStats.stats.hp == -1:
		self.hp = max_hp
	else:
		self.hp = PlayerStats.stats.hp
	shootTimer.wait_time = shoot_delay


func _physics_process(delta: float) -> void:
	var direction: Vector2 = get_global_mouse_position() - Vector2(0, 15) - global_position
	var motion: Vector2 = direction * 0.2
	# Tilt the spaceship
	if direction.x > 2 or direction.x < -2:
		self.curvature += direction.normalized().x * delta * 2
	else:
		self.curvature = lerp(curvature, 0, 0.05)
		
	# Update the intensity of the engine particles
	_update_engine_particles(direction.y)
	
	if can_move:
		position += motion
	
	
func _update_engine_particles(velocity_y: float) -> void:
	if velocity_y < -4:
		# Increase the intensity
		engine_state = HIGH
	elif velocity_y > 4:
		# Decrease the intensity
		engine_state = LOW
	else:
		# Normal intensity
		engine_state = NORMAL
		
	# If the state changed, update the particles parameters
	if engine_state != previous_engine_state:
		engineParticlesTween.interpolate_property(engineParticles, "scale", engineParticles.scale,
												  ENGINE_PARTICLES_SCALES[engine_state], 1,
												  Tween.TRANS_SINE, Tween.EASE_OUT)
		engineParticlesTween.start()
		previous_engine_state = engine_state
	
	
func take_damage(dam: int) -> void:
	self.hp -= dam
	if hp == 0:
		emit_signal("destroyed")
		_spawn_dead_particles()
		queue_free()
	
	
func set_hp(new_hp: int) -> void:
	var previous_hp: int = hp
	hp = clamp(new_hp, 0, max_hp)
	emit_signal("hp_changed", previous_hp, hp)
	
	
func set_shoot_delay(new_value: float) -> void:
	shoot_delay = new_value
	get_node("ShootTimer").wait_time = shoot_delay
	
	
func set_curvature(new_value: float) -> void:
	# Update the shader curvature
	curvature = clamp(new_value, -1, 1)
	sprite.material.set_shader_param("curvature", curvature)
	
	
func set_projectile_damage(new_value: int) -> void:
	projectile_damage = new_value
	emit_signal("projectile_damage_changed", projectile_damage)
	
	
func set_projectile_speed(new_value: int) -> void:
	projectile_speed = new_value
	emit_signal("projectile_speed_changed", projectile_speed)
	
	
func set_double_shoot(new_value: bool) -> void:
	double_shoot = new_value
	emit_signal("double_shoot_changed", double_shoot)
	
	
func set_plasma_projectiles(new_value: bool) -> void:
	plasma_projectiles = new_value
	emit_signal("plasma_projectiles_changed", plasma_projectiles)


func _on_ShootTimer_timeout() -> void:
	# Spawn a middle projectile or two projectiles if it has the DoubleCanon artifact
	# If has the double shoot artifact, spawn two projectiles for each canon. Else, spawn one
	if is_shooting:
		if double_canon:
			if double_shoot:
				_spawn_projectile(leftCanon.global_position + Vector2.LEFT)
				_spawn_projectile(rightCanon.global_position + Vector2.LEFT)
				_spawn_projectile(leftCanon.global_position + Vector2.RIGHT)
				_spawn_projectile(rightCanon.global_position + Vector2.RIGHT)
			else:
				_spawn_projectile(leftCanon.global_position)
				_spawn_projectile(rightCanon.global_position)
		else:
			if double_shoot:
				_spawn_projectile(middleCanon.global_position + Vector2.LEFT)
				_spawn_projectile(middleCanon.global_position + Vector2.RIGHT)
			else:
				_spawn_projectile(middleCanon.global_position)
	
	
func _spawn_projectile(pos: Vector2) -> void:
	# Spawn a projectile
	var Projectile: Area2D = projectile_scene.instance()
	Projectile.position = pos
	if plasma_projectiles:
		Projectile.get_node("Sprite").modulate = Color(0.2, 0.7, 0.8)
		Projectile.get_node("Light2D").modulate = Color(0.2, 0.7, 0.8)
	Projectile.damage = projectile_damage
	Projectile.speed = projectile_speed
	get_parent().add_child(Projectile)
	shootSound.play()
	
	
func _spawn_dead_particles() -> void:
	var particles: Particles2D = DEAD_PARTICLES_SCENE.instance()
	particles.position = position
	get_parent().add_child(particles)


func _on_ArtifactsExpositor_artifact_collected(name: String) -> void:
	collectArtifactSound.play()
	var artifact_path: String = "res://Artifacts/" + name + ".tscn"
	var Artifact: Node = load(artifact_path).instance()
	artifactContainer.add_child(Artifact)
	if name == "ReinforcedArmor":
		self.hp += 2
		PlayerStats.stats.hp += 2
	PlayerStats.add_artifact(name)
