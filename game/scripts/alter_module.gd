# AlterModule.tscn
extends SpellModule
class_name AlterModule

enum TargetType {
	PARENT,
	PLAYER,
	CLOSEST,
	RADNOM
}

@export var target_type: TargetType
@export var effect: SpellEffect

func _init(target, effect):
	self.target_type = target
	self.effect = effect
	
	print("Alter: Created!")
	
func _to_string():
	return "AlterModule(target_type: %s, effect: %s, next_mod: %s)" % [enum_to_string(TargetType, target_type), effect, "None" if next_module == null else next_module]

func start(_direction: Vector2):
	print("Alter: Looking for target!")
	var target = get_target()
	if target:
		print("Alter: Found target!")
		effect.apply_to(target)
		emit_signal("trigger_next_module", mod_chain, target)
	queue_free()

func find_closest_enemy() -> Object:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var closest_distance = INF

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	if closest_enemy:
		return closest_enemy
	else:
		return null # Default direction if no enemies are found

func get_target():
	return find_closest_enemy()

func apply_effect(target):
	# Apply effect to target
	pass
