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
