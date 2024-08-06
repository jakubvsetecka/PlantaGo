extends Node2D

class_name SpellModule

# var position: Vector2
var next_module: SpellModule

func start(direction: Vector2):
	pass

func on_hit(target):
	if next_module:
		next_module.position = position
		next_module.start(Vector2.ZERO)
