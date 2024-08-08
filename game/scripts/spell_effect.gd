class_name SpellEffect
extends Node

enum EffectType {
	ALTER_HEALTH,
	ALTER_SPEED,
	ALTER_POSITION,
}

func _init():
	pass

func enum_to_string(my_enum, enum_value: int) -> String:
	var keys = my_enum.keys()
	if enum_value >= 0 and enum_value < keys.size():
		return keys[enum_value]
	else:
		return "INVALID_ENUM_VALUE"
		
func _to_string():
	return ""
