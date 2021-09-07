extends "res://Enemies/Enemy.gd"

const DIRECTIONS: PoolVector2Array = PoolVector2Array([Vector2.LEFT, Vector2.ZERO, Vector2.RIGHT])

export(int) var projectiles_speed: int = 20

var side_speed: int = 10
var move_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var curvature: float = 0.0

onready var changeDirectionTimer: Timer = get_node("ChangeDirectionTimer")
onready var directionTween: Tween = get_node("DirectionTween")
onready var leftCanon: Position2D = get_node("LeftCanon")
onready var rightCanon: Position2D = get_node("RightCanon")

func _ready() -> void:
	_on_ChangeDirectionTimer_timeout()


func _physics_process(delta: float) -> void:
	position.y += front_speed * delta
	
	velocity = move_direction * side_speed
	velocity = move_and_slide(velocity)
	
	# Update the shader curvature
	sprite.material.set_shader_param("curvature", curvature)
	
	# If the ship is in the borders, change the direction
	if position.x - ship_width/2 - 2 < 0 or position.x + ship_width/2 + 2 > Utils.SCREEN_WIDTH:
		_on_ChangeDirectionTimer_timeout()
	
	
func take_damage(dam: int) -> void:
	hp -= dam
	if hp <= 0:
		_spawn_explosion()
		_spawn_scrap((randi() % 2) + 1)
		queue_free()


func _on_ShootTimer_timeout() -> void:
	_spawn_projectile(leftCanon.global_position)
	_spawn_projectile(rightCanon.global_position)


func _on_ChangeDirectionTimer_timeout() -> void:
	# Choose a random horizontal direction
	var direction: Vector2 = DIRECTIONS[randi() % DIRECTIONS.size()]
	if (direction == Vector2.LEFT and position.x < Utils.SCREEN_WIDTH * 0.1) or (
		direction == Vector2.RIGHT and position.x > Utils.SCREEN_WIDTH * 0.9):
			_on_ChangeDirectionTimer_timeout()
	else:
		if direction != move_direction:
			directionTween.interpolate_property(self, "move_direction", move_direction, direction, 0.5)
			var current_curvature: float = sprite.material.get_shader_param("curvature")
			directionTween.interpolate_property(self, "curvature",
												current_curvature,
												direction.x, 0.5)
			directionTween.start()
			changeDirectionTimer.start()
