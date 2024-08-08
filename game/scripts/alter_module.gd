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
	pass

func _to_string():
	return "AlterModule(target_type: %s, effect: %s, next_mod: %s)" % [enum_to_string(TargetType, target_type), effect, "None" if next_module == null else next_module]

func start(_direction: Vector2):
	var target = get_target()
	if target:
		apply_effect(target)
		on_hit(target)
	queue_free()

func get_target():
	# Implement logic to find target based on target_type
	pass

func apply_effect(target):
	# Apply effect to target
	pass
