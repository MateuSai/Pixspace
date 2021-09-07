extends KinematicBody2D

const SPRITES: Array = [preload("res://Scrap/Scrap 1.pxo"), preload("res://Scrap/Scrap 2.pxo"),
						preload("res://Scrap/Scrap 3.pxo")]
const FRICTION: float = 0.1

var initial_impulse: int = 80
var accerelation: int = 1000
var velocity: Vector2 = Vector2.ZERO

onready var sprite: Sprite = get_node("Sprite")
onready var player: KinematicBody2D = get_parent().get_node("Spaceship")

func _ready() -> void:
	sprite.texture = SPRITES[randi() % SPRITES.size()]
	if randi() % 2 == 0:
		velocity.x += rand_range(initial_impulse - 5, initial_impulse + 5)
	else:
		velocity.x -= rand_range(initial_impulse - 5, initial_impulse + 5)
	
	
func _physics_process(delta: float) -> void:
	if player != null:
		var direction: Vector2 = (player.position - position).normalized()
		velocity += direction * accerelation * delta
	velocity = move_and_slide(velocity)
	velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION)
