class_name AreaPosition
extends Node

enum IniPos {
	ON_PARENT,
	ON_PLAYER,
	CLOSEST_ENEMY,
	RELATIVE_TO_PLAYER,
	RANDOM
}

enum PosType {
	STATIC,
	DYNAMIC
}

enum DirType {
	FOLLOW_PARENT,
	RANDOM,
	NONE
}

var initial_pos: IniPos
var type: PosType
var direction: DirType
var size_increase

func _init(intial_pos, type, dir = DirType.NONE, size_inc = 0.0):
	self.initial_pos = initial_pos
	self.type = type
	self.direction = dir
	self.size_increase = size_inc
	pass

func enum_to_string(my_enum, enum_value: int) -> String:
	var keys = my_enum.keys()
	if enum_value >= 0 and enum_value < keys.size():
		return keys[enum_value]
	else:
		return "INVALID_ENUM_VALUE"

func _to_string():
	return "AreaPosition(initial_pos: %s, type: %s, direction: %s, size_increase: %d)" % [enum_to_string(IniPos, initial_pos), enum_to_string(PosType, type), enum_to_string(DirType, direction), size_increase]
