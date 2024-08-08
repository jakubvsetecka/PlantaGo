class_name SpellConstructor
extends Node

func _ready():
	pass

func construct_shape(shape_dict: Dictionary):
	var type = shape_dict.get("type")
	var shape
	var shape_object
	match type:
		"rect":
			shape = RectShape.new(shape_dict.get("outer_width"), shape_dict.get("inner_width"), shape_dict.get("length"), shape_dict.get("rotation"))
			pass
		"donut":
			shape = DonutShape.new(shape_dict.get("outer_radius"), shape_dict.get("inner_radius"), shape_dict.get("angle"), shape_dict.get("rotation"))
			pass
		_:
			print("Unknown shape")
	return shape

func construct_effect(effect_dict: Dictionary):
	var type = effect_dict.get("type")
	var effect
	match type:
		"one_time":
			effect = OneTimeEffect.new(effect_dict.get("effect_type"), effect_dict.get("value"))
			pass
		"over_time":
			effect = OverTimeEffect.new(effect_dict.get("duration"), effect_dict.get("tick_per_sec"), effect_dict.get("effect_type"), effect_dict.get("value"))
			pass
		_:
			print("Unknown effect")
	return effect

func construct_position(pos_dict: Dictionary):
	var type = pos_dict.get("type")
	var pos
	match type:
		"static":
			pos = AreaPosition.new(pos_dict.get("initial"), pos_dict.get("type"))
			pass
		"dynamic":
			pos = AreaPosition.new(pos_dict.get("initial"), pos_dict.get("type"), pos_dict.get("direction"), pos_dict.get("size_inc"))
			pass
		_:
			print("Unknown area position")
	return pos

func construct_projectile(module_dict: Dictionary) -> ProjectileModule:
	var velocity = module_dict.get("velocity")
	var shape = construct_shape(module_dict.get("shape"))
	var effect = construct_effect(module_dict.get("effect"))
	var projectile = ProjectileModule.new(velocity, shape, effect)
	
	return projectile

func construct_area(module_dict: Dictionary) -> AreaModule:
	var ttl = module_dict.get("ttl")
	var shape = construct_shape(module_dict.get("shape"))
	var position = construct_position(module_dict.get("position"))
	var effect = construct_effect(module_dict.get("effect"))
	var area = AreaModule.new(ttl, shape, position, effect)
	return area

func construct_alter(module_dict: Dictionary) -> AlterModule:
	var target = module_dict.get("target")
	var effect = construct_effect(module_dict.get("effect"))
	var alter = AlterModule.new(target, effect)
	
	return alter

func construct_module(module_dict: Dictionary) -> SpellModule:
	var type = module_dict.get("type")
	var spell_module: SpellModule
	match type:
		"projectile":
			spell_module = construct_projectile(module_dict)
			pass
		"area":
			spell_module = construct_area(module_dict)
			pass
		"alter":
			spell_module = construct_alter(module_dict)
			pass
		_:
			print("Unexpected data")
	
	return spell_module

func construct_spell(spell_dict: Dictionary) -> Spell:
	var mod_chain: Array = spell_dict.get("spell_chain")
	var previous_mod = null
	for i in range(mod_chain.size() - 1, -1, -1):
		var current_mod = construct_module(mod_chain[i])
		if previous_mod:
			current_mod.next_module = previous_mod
		previous_mod = current_mod
	
	var new_spell = Spell.new(spell_dict.get("name"), previous_mod, spell_dict.get("color_scheme"), spell_dict.get("frequency"))
	return new_spell
