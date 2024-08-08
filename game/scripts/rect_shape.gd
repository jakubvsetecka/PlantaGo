extends SpellShape

class_name RectShape

var outer_width = 0
var inner_width = 0
var length = 0
var rotation = 0

func _init(outer, inner, len, rot):
	outer_width = outer
	inner_width = inner
	length = len
	rotation = rot
