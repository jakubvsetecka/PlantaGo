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

func enum_to_string(my_enum, enum_value: int) -> String:
	var keys = my_enum.keys()
	if enum_value >= 0 and enum_value < keys.size():
		return keys[enum_value]
	else:
		return "INVALID_ENUM_VALUE"
		
func _to_string():
	return "didnt propagate to children"
