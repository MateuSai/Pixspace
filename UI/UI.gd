extends CanvasLayer

const ARMOUR_POINT_SCENE: PackedScene = preload("res://UI/ArmorPoint.tscn")
const MIN_SHIELD_BAR_VALUE: int = 22
const NUM_SHIELD_BAR_VALUES: int = 58

var max_shield_points: int = 0
var shield_point_recover_time: float = 0.0

var scrap: int = PlayerStats.stats.scrap

onready var armorPointsContainer: HBoxContainer = get_node("ArmorPointsContainer")
onready var shieldBar: TextureProgress = get_node("ShieldBar")
onready var shieldBarTween: Tween = get_node("ShieldBar/Tween")
onready var scrapLabel: Label = get_node("Scrap/HBoxContainer/Label")

func _ready() -> void:
	scrapLabel.text = str(scrap)


func add_armour_points(amount: int) -> void:
	for i in amount:
		var armorPoint: TextureRect = ARMOUR_POINT_SCENE.instance()
		
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
		
		armorPoint.material.set_shader_param("noise_tex", noise_texture)
		armorPointsContainer.add_child(armorPoint)
	
	
func delete_armour_points(previous_armour_points: int, new_armour_points: int) -> void:
	for i in range(previous_armour_points, new_armour_points, -1):
		_dissolve_armor_point(i - 1)
		
		
func _dissolve_armor_point(index: int) -> void:
	var armorPoint: TextureRect = armorPointsContainer.get_child(index)
	var tween: Tween = Tween.new()
	tween.interpolate_property(armorPoint.get_material(), "shader_param/burn_position", -0.05, 1, 0.7,
							   Tween.TRANS_SINE, Tween.EASE_OUT)
	add_child(tween)
	tween.start()
	
	yield(tween, "tween_completed")
	armorPoint.queue_free()
	tween.queue_free()


func _on_Spaceship_hp_changed(previous_hp: int, new_hp: int) -> void:
	if new_hp > previous_hp:
		add_armour_points(new_hp - previous_hp)
	elif new_hp < previous_hp:
		delete_armour_points(previous_hp, new_hp)


func _on_EnergyShield_shield_points_changed(previous_shield_points: int, actual_shield_points: int) -> void:
	var tween_type: int = Tween.TRANS_SINE
	var tween_time: float = 0.3
	if actual_shield_points < previous_shield_points:
		tween_type = Tween.TRANS_ELASTIC
	else:
		tween_type = Tween.TRANS_SINE
		tween_time = shield_point_recover_time
	var shield_percentage: float = float(actual_shield_points) / max_shield_points
	var new_value: int = round(NUM_SHIELD_BAR_VALUES * shield_percentage) + MIN_SHIELD_BAR_VALUE
	shieldBarTween.interpolate_property(shieldBar, "value", shieldBar.value, new_value, tween_time,
										tween_type, Tween.EASE_OUT)
	shieldBarTween.start()


func _on_EnergyShield_max_shield_points_changed(actual_max: int):
	max_shield_points = actual_max
	get_node("ShieldBar").rect_size.x = max_shield_points * 4


func _on_ScrapCollector_scrap_collected(amount: int) -> void:
	scrap += amount
	scrapLabel.text = str(scrap)


func _on_EnergyShield_recovering_speed_changed(new_value: float) -> void:
	shield_point_recover_time = new_value
