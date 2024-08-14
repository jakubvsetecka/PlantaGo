class_name OneTimeEffect
extends SpellEffect

func _init(type, value):
	self.type = EffectType.get(str(type).to_upper())
	self.value = value

func _to_string():
	return "OneTimeEffect(type: %s, value: %d)" % [enum_to_string(EffectType, type), value]

func apply_to(target: Node2D):
	match type:
		EffectType.ALTER_HEALTH:
			print("Altering Health")
			target.hit(-value, Vector2.ZERO)
			pass
		EffectType.ALTER_SPEED:
			print("Altering Speed")
			target.speed += value
			pass
		EffectType.ALTER_POSITION:
			target.position = Vector2.ZERO
			pass
