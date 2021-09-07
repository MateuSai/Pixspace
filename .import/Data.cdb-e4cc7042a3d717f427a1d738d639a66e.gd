extends Node

const CastleDB = preload("res://addons/thejustinwalsh.castledb/castledb_types.gd")

class Artifacts:

	const DoubleCanon := "DoubleCanon"
	const DoubleShoot := "DoubleShoot"
	const FastShoot := "FastShoot"
	const FastBullets := "FastBullets"
	const ReinforcedArmor := "ReinforcedArmor"
	const ImprovedShield := "ImprovedShield"
	const LargeProjectiles := "LargeProjectiles"
	const AutomaticTurret := "AutomaticTurret"
	const PlasmaProjectiles := "PlasmaProjectiles"

	class ArtifactsRow:
		var name := ""
		var available := false
		var icon := ""
		var description := ""
		
		func _init(name = "", available = false, icon = "", description = ""):
			self.name = name
			self.available = available
			self.icon = icon
			self.description = description
	
	var all = [ArtifactsRow.new(DoubleCanon, true, "Artifacts/Double Canon Icon.pxo", "-Two canons"), ArtifactsRow.new(DoubleShoot, true, "Artifacts/Double Shoot Icon.pxo", "-2 projectiles for canon\n-Less damage"), ArtifactsRow.new(FastShoot, true, "Artifacts/Fast Shoot Icon.pxo", "-Increase the fire speed"), ArtifactsRow.new(FastBullets, true, "Artifacts/Fast Bullets Icon.pxo", "-Increase projectile speed"), ArtifactsRow.new(ReinforcedArmor, true, "Artifacts/Reinforced Armor Icon.pxo", "-More health"), ArtifactsRow.new(ImprovedShield, true, "Artifacts/Improved Shield Icon.pxo", "-Increase shield capacity\n-Slightly increase shield recovery time"), ArtifactsRow.new(LargeProjectiles, true, "Artifacts/Large Projectiles Icon.pxo", "-More damage\n-More speed"), ArtifactsRow.new(AutomaticTurret, false, "Artifacts/Automatic Turret Icon.pxo", "-Automatic turret"), ArtifactsRow.new(PlasmaProjectiles, true, "Artifacts/Plasma Projectiles Icon.pxo", "-Increase damage")]
	var index = {DoubleCanon: 0, DoubleShoot: 1, FastShoot: 2, FastBullets: 3, ReinforcedArmor: 4, ImprovedShield: 5, LargeProjectiles: 6, AutomaticTurret: 7, PlasmaProjectiles: 8}
	
	func get(id:String) -> ArtifactsRow:
		if index.has(id):
			return all[index[id]]
		return null

	func get_index(idx:int) -> ArtifactsRow:
		if idx < all.size():
			return all[idx]
		return null

class Stages:

	const stage_1 := "stage_1"
	const stage_2 := "stage_2"
	const stage_3 := "stage_3"
	const stage_4 := "stage_4"
	const stage_5 := "stage_5"
	const stage_6 := "stage_6"
	const stage_7 := "stage_7"
	const stage_8 := "stage_8"

	class StagesRow:
		var id := ""
		var waves := 0
		var boss_stage := false
		var has_enemy_ship := false
		var has_enemy_sniper := false
		var has_enemy_chaser := false
		var has_boss1 := false
		var has_boss2 := false
		var doble_spawn_probability := 0
		var triple_spawn_probability := 0
		
		func _init(id = "", waves = 0, boss_stage = false, has_enemy_ship = false, has_enemy_sniper = false, has_enemy_chaser = false, has_boss1 = false, has_boss2 = false, doble_spawn_probability = 0, triple_spawn_probability = 0):
			self.id = id
			self.waves = waves
			self.boss_stage = boss_stage
			self.has_enemy_ship = has_enemy_ship
			self.has_enemy_sniper = has_enemy_sniper
			self.has_enemy_chaser = has_enemy_chaser
			self.has_boss1 = has_boss1
			self.has_boss2 = has_boss2
			self.doble_spawn_probability = doble_spawn_probability
			self.triple_spawn_probability = triple_spawn_probability
	
	var all = [StagesRow.new(stage_1, 3, false, true, false, false, false, false, 10, 0), StagesRow.new(stage_2, 3, false, true, true, false, false, false, 30, 5), StagesRow.new(stage_3, 4, false, true, true, false, false, false, 50, 10), StagesRow.new(stage_4, 1, true, false, false, false, true, false, 0, 0), StagesRow.new(stage_5, 4, false, true, true, true, false, false, 60, 15), StagesRow.new(stage_6, 4, false, true, true, true, false, false, 80, 20), StagesRow.new(stage_7, 4, false, true, true, true, false, false, 70, 30), StagesRow.new(stage_8, 1, true, false, false, false, false, true, 0, 0)]
	var index = {stage_1: 0, stage_2: 1, stage_3: 2, stage_4: 3, stage_5: 4, stage_6: 5, stage_7: 6, stage_8: 7}
	
	func get(id:String) -> StagesRow:
		if index.has(id):
			return all[index[id]]
		return null

	func get_index(idx:int) -> StagesRow:
		if idx < all.size():
			return all[idx]
		return null

var artifacts := Artifacts.new()
var stages := Stages.new()
