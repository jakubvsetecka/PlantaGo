# AlterModule.tscn
extends SpellModule

@export var target_type: String = "closest_enemy"

func initialize(data: Dictionary):
	target_type = data.get("target", target_type)
	# Set up effect based on data

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
