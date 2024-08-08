class_name OverTimeEffect
extends SpellEffect

var duration: float = 0.0
var ticks_per_sec: float = 1.0
var type: String = ""
var value: float = 0.0

func _init(duration, ticks_per_sec, type, value):
	self.duration = duration
	self.ticks_per_sec = ticks_per_sec 
	self.type = type
	self.value = value
