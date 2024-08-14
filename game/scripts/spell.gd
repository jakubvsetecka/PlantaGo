extends Node2D

class_name Spell

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var spell_name: String = "unknown"
var mod_chain: Stack
@export var color_scheme = "#ffffff"
@export var frequency = 0

func _ready():
	pass
	
func _init(name, mod_chain, color_scheme, frequency):
	self.spell_name = name
	self.mod_chain = mod_chain
	self.color_scheme = color_scheme
	self.frequency = frequency
	
func _to_string():
	return "Spell(name: %s, mod_chain: %s, color_scheme: %s, frequency: %d)" % [spell_name, str(mod_chain), color_scheme, frequency]

func cast(initial_pos: Vector2):
	if mod_chain:
		print("spell casted")
		var module = GlobalSpellConstructor.construct_module(mod_chain)
		module.connect("trigger_next_module", Callable(self, "_on_trigger_next_module"))
		add_child(module)
		module.start(initial_pos)
		
func _on_trigger_next_module(mod_chain, target):
	print("Trying to create next module")
	if not mod_chain.is_empty():
		print("spell casted")
		var module = GlobalSpellConstructor.construct_module(mod_chain)
		module.connect("trigger_next_module", Callable(self, "_on_trigger_next_module"))
		add_child(module)
		module.start(target.global_position)
