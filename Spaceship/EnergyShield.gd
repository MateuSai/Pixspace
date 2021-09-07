extends Area2D

var max_shield_points: int = 5 setget set_max_shield_points
var shield_points: int = max_shield_points setget set_shield_points
signal shield_points_changed(previous_shield_points, actual_shield_points)
signal max_shield_points_changed(actual_max)
var recovering: bool = false
var recovering_speed: float = 1.5 setget set_recovering_speed
signal recovering_speed_changed(new_value)

onready var sprite: Sprite = get_node("Sprite")
onready var collisionShape: CollisionShape2D = get_node("CollisionShape2D")
onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")
onready var recoverTimer: Timer = get_node("RecoverTimer")

func _init() -> void:
	modulate = Color(1, 1, 1, 0)
	
	
func _enter_tree() -> void:
	emit_signal("max_shield_points_changed", max_shield_points)
	emit_signal("recovering_speed_changed", recovering_speed)
	

func _ready() -> void:
	collisionShape.disabled = false
	sprite.scale = Vector2(1, 1)


func set_shield_points(new_value: int) -> void:
	var previous_shield_points: int = shield_points
	shield_points = clamp(new_value, 0, max_shield_points)
	emit_signal("shield_points_changed", previous_shield_points, shield_points)
	
	
func set_max_shield_points(new_value: int) -> void:
	max_shield_points = new_value
	shield_points = max_shield_points
	emit_signal("max_shield_points_changed", max_shield_points)
	
	
func set_recovering_speed(new_value: float) -> void:
	recovering_speed = new_value
	emit_signal("recovering_speed_changed", recovering_speed)


func take_damage(dam: int) -> void:
	recovering = false
	self.shield_points -= dam
	if shield_points == 0:
		animationPlayer.play("desactivate")
	else:
		animationPlayer.play("damage")
	recovering = false
	recoverTimer.start()


func _on_RecoverTimer_timeout() -> void:
	if shield_points == 0:
		animationPlayer.play("activate")
	recovering = true
	while recovering:
		self.shield_points += 1
		if shield_points == max_shield_points:
			recovering = false
		yield(get_tree().create_timer(recovering_speed), "timeout")


func _on_Spaceship_hp_changed(_previous_hp: int, _new_hp: int):
	recovering = false
	recoverTimer.start()
