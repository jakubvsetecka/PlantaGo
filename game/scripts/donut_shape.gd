extends SpellShape

class_name DonutShape

var outer_radius = 0
var inner_radius = 0
var angle = 0
var rotation = 0

func _init(outer, inner, ang, rot):
	outer_radius = outer
	inner_radius = inner
	angle = ang
	rotation = rot
	pass
