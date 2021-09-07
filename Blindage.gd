extends StaticBody2D

export(int) var hp: int = 0
var is_destroyed: bool = false

onready var sprite: Sprite = get_node("Sprite")
onready var tween: Tween = get_node("Tween")
onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	var noise: OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 3
	noise.period = 64
	noise.persistence = 0.5
	noise.lacunarity = 2
	
	var noise_texture: NoiseTexture = NoiseTexture.new()
	noise_texture.width = 512
	noise_texture.height = 256
	noise_texture.noise = noise
	
	material.set_shader_param("noise_tex", noise_texture)


func take_damage(dam: int) -> void:
	hp -= dam
	if not is_destroyed:
		if hp <= 0:
			is_destroyed = true
			sprite.material = material
			tween.interpolate_property(sprite.get_material(), "shader_param/burn_position", -0.05, 1, 0.7,
							   Tween.TRANS_SINE, Tween.EASE_OUT)
			tween.start()
		else:
			animationPlayer.play("flash")


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
