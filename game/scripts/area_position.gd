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
