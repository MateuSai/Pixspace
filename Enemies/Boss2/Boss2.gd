extends "res://Enemies/Enemy.gd"

onready var leftHangar: Position2D = get_node("Hangars/LeftHangar")
onready var rightHangar: Position2D = get_node("Hangars/RightHangar")
onready var deployTimer: Timer = get_node("Hangars/DeployTimer")

onready var moveTween: Tween = get_node("MoveTween")

onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	moveTween.interpolate_property(self, "position", Vector2(position.x, -ship_height/2),
								   Vector2(position.x, ship_height/2), 1)
	moveTween.start()


func take_damage(dam: int) -> void:
	hp -= dam
	animationPlayer.play("flash")
	if hp <= 0:
		_spawn_multiple_explosions()
		yield(get_tree().create_timer(0.5), "timeout")
		_spawn_scrap((randi() % 10) + 10)
		#get_parent().get_parent().give_artifact(REWARD_ARTIFACT_NAME, position)
		queue_free()
		

func _on_DeployTimer_timeout():
	_spawn_ship(leftHangar.global_position)
	_spawn_ship(rightHangar.global_position)
	
	
func _spawn_ship(pos: Vector2) -> void:
	var ship: KinematicBody2D = preload("res://Enemies/Ship/EnemyShip.tscn").instance()
	ship.position = pos
	get_parent().add_child(ship)


func _on_MoveTween_tween_completed(_object: Object, _key: NodePath):
	deployTimer.start()
