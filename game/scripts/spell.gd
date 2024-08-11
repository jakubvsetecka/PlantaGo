extends Node2D

class_name Spell

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var spell_name: String = "unknown"
@export var first_module: SpellModule
@export var color_scheme = "#ffffff"
@export var frequency = 0

func _ready():
	pass
	
func _init(name, first_module, color_scheme, frequency):
	self.spell_name = name
	self.first_module = first_module
	self.color_scheme = color_scheme
	self.frequency = frequency

func _to_string():
	return "Spell(name: %s, mod_chain: %s, color_scheme: %s, frequency: %d)" % [spell_name, str(first_module), color_scheme, frequency]

func cast(initial_pos: Vector2):
	add_child(first_module)
	if first_module:
		first_module.start(initial_pos)
