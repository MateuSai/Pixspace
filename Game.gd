extends "res://LevelScene.gd"

var stage: int = PlayerStats.stats.stage
var stage_data = Data.stages.get_index(stage - 1)
#var stage_data = Data.stages.get_index(3)

var spaceship_destroyed: bool = false

var enemies: Array = []
var waves: int = stage_data.waves + (randi() % 4) - 1
var waves_spawned: int = 0

onready var enemyContainer: Node2D = get_node("Enemies")
onready var spawnTimer: Timer = get_node("Timer")
onready var pauseScreen: CanvasLayer = get_node("Pause")
onready var gameOverScreen: CanvasLayer = get_node("GameOverScreen")

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if stage_data.boss_stage:
		waves = 1
	
	if stage_data.has_enemy_ship:
		enemies.append(preload("res://Enemies/Ship/EnemyShip.tscn"))
	if stage_data.has_enemy_sniper:
		enemies.append(preload("res://Enemies/Sniper/EnemySniper.tscn"))
	if stage_data.has_enemy_chaser:
		enemies.append(preload("res://Enemies/Chaser/EnemyChaser.tscn"))
	if stage_data.has_boss1:
		enemies.append(preload("res://Enemies/Boss1/Boss1.tscn"))
	if stage_data.has_boss2:
		enemies.append(preload("res://Enemies/Boss2/Boss2.tscn"))


func _ready() -> void:
	gameOverScreen.get_node("VBoxContainer").hide()
	_enter_level()


func _on_Timer_timeout():
	var num_enemies_to_spawn: int = 1
	var rand: int = randi() % 100
	if rand < stage_data.triple_spawn_probability:
		num_enemies_to_spawn = 3
	elif stage_data.triple_spawn_probability <= rand and rand < stage_data.doble_spawn_probability + stage_data.triple_spawn_probability:
		num_enemies_to_spawn = 2
	# Spawn enemies
	for i in num_enemies_to_spawn:
		var Enemy: KinematicBody2D = enemies[randi() % enemies.size()].instance()
		if stage_data.boss_stage:
			Enemy.position = Vector2(Utils.SCREEN_WIDTH/2, -Enemy.get_node("Sprite").texture.get_size().y/2)
		else:
			Enemy.position = Vector2(rand_range(5, Utils.SCREEN_WIDTH - 5), -10)
		enemyContainer.add_child(Enemy)
		Enemy.connect("tree_exited", self, "_on_enemy_exited_tree")
	waves_spawned += 1
	
	# When all enemies spawned, stop the timer
	if waves_spawned >= waves:
		spawnTimer.stop()
		
		
func _on_enemy_exited_tree() -> void:
	# If it is the last enemy, exit the level
	if enemyContainer.get_child_count() == 0 and waves_spawned >= waves and not spaceship_destroyed:
		if stage_data.boss_stage:
			yield(get_tree().create_timer(2), "timeout")
		_exit_level()
		PlayerStats.stats.stage += 1
		PlayerStats.stats.scrap += spaceship.get_node("UI").scrap
		if stage % 2 == 0:
			SceneChanger.change_scene("res://Game.tscn")
		else:
			SceneChanger.change_scene("res://ArtifactSelector.tscn")
			
			
func give_artifact(artifact_name: String, artifact_initial_position: Vector2) -> void:
	var tween: Tween = Tween.new()
	
	var artifactSprite: Sprite = Sprite.new()
	artifactSprite.texture = load(Data.artifacts.get(artifact_name).icon)
	artifactSprite.position = artifact_initial_position
	add_child(artifactSprite)
	
	tween.interpolate_property(artifactSprite, "position", artifactSprite.position, spaceship.position, 0.6)
	tween.interpolate_property(artifactSprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6,
							   Tween.TRANS_CUBIC, Tween.EASE_IN)
	add_child(tween)
	tween.start()
	
	yield(tween, "tween_completed")
	spaceship._on_ArtifactsExpositor_artifact_collected(artifact_name)
	artifactSprite.queue_free()
	tween.queue_free()


func _on_Spaceship_destroyed() -> void:
	spaceship_destroyed = true
	pauseScreen.queue_free()
	gameOverScreen.get_node("VBoxContainer").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
