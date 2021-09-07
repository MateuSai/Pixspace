extends VBoxContainer

var price: int = 0

onready var spaceship: KinematicBody2D = owner.get_node("Spaceship")
onready var priceLabel: Label = get_node("HBoxContainer/Label")
onready var buyParticles: Particles2D = get_node("BuyParticles")
onready var sound: AudioStreamPlayer = get_node("Sound")

func _on_ArtifactSelector_ready() -> void:
	price = 10 +  5 * PlayerStats.stats.stage
	priceLabel.text = str(price)


func _on_TextureButton_pressed() -> void:
	if PlayerStats.stats.scrap >= price and spaceship.hp < spaceship.max_hp:
		buyParticles.emitting = true
		sound.play()
		PlayerStats.stats.scrap -= price
		PlayerStats.stats.hp += 1
		spaceship.hp += 1
		spaceship.get_node("UI")._on_ScrapCollector_scrap_collected(-price)
