class_name OverTimeEffect
extends SpellEffect

var duration: float = 0.0
var ticks_per_sec: float = 1.0
var type: EffectType
var value: float = 0.0

func _init(duration, ticks_per_sec, type, value):
	self.duration = duration
	self.ticks_per_sec = ticks_per_sec 
	self.type = type
	self.value = value

func _to_string():
	return "OverTimeEffect(duration: %d, ticks_per_sec: %d, type: %s, value: %d)" % [duration, ticks_per_sec, enum_to_string(EffectType, type), value]
