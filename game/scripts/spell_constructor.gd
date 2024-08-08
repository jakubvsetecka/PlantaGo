extends Node

class_name SpellConstructor

func _ready():
	pass

func construct_projectile():
	pass

func construct_area():
	pass

func construct_alter():
	pass

func construct_spell(spell_dict: Dictionary) -> Spell:
	var SpellScene = preload("res://scenes/spell.tscn")
	var new_spell = SpellScene.instantiate()
	
	new_spell.name = spell_dict.get("name")
	print("new_spell name: " + str(new_spell.name))
	
	return new_spell
