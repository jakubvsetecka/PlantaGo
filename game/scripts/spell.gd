extends Node2D

class_name Spell

@export var spell_data: Dictionary

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var spell_chain: SpellModule
var direction = Vector2.ZERO


func _ready():
	initialize_spell(spell_data)

func initialize_spell(data: Dictionary):
	# Initialize spell properties
	$NameLabel.text = data.get("name", "Unknown Spell")
	sprite.modulate = Color(data.get("color_scheme", "#ffffff"))
	spell_chain = create_spell_chain(data.get("spell_chain", []))

func create_spell_chain(chain_data: Array) -> SpellModule:
	var first_module = null
	var current_module = null

	for module_data in chain_data:
		var new_module = create_spell_module(module_data)
		if new_module:
			add_child(new_module)
			if not first_module:
				first_module = new_module
			if current_module:
				current_module.next_module = new_module
			current_module = new_module

	return first_module

func create_spell_module(module_data: Dictionary) -> SpellModule:
	var module_type = module_data.get("type", "")
	var module_scene: PackedScene
	
	match module_type:
		"projectile":
			module_scene = preload("res://scenes/projectile_module.tscn")
		"area":
			module_scene = preload("res://scenes/area_module.tscn")
		"alter":
			module_scene = preload("res://scenes/alter_module.tscn")
		_:
			return null

	var module_instance = module_scene.instantiate()
	module_instance.initialize(module_data)
	return module_instance

func cast(start_position: Vector2, direction: Vector2):
	if spell_chain:
		global_position = start_position
		spell_chain.start(direction)
		animation_player.play("cast")
