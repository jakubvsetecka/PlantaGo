class_name OneTimeEffect
extends SpellEffect

var type: EffectType
var value: float = 0.0

func _init(type, value):
	self.type = EffectType.get(str(type).to_upper())
	self.value = value

func _to_string():
	return "OneTimeEffect(type: %s, value: %d)" % [enum_to_string(EffectType, type), value]
