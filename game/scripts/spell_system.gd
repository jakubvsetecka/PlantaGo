extends Node

@export var spell_config_path: String = "res://configs/spells.json"
@onready var spell_constructor = $SpellConstructor

var spell_config: Dictionary
var spell_scene: PackedScene = preload("res://scenes/Spell.tscn")
var spells: Array = []
var current_spell: int = 0

func _ready():
	print("spell system ready")
	load_spell_config()
	run()
	print(self)
	
func _to_string() -> String:
	return "\n".join(range(spells.size()).map(func(idx): return "%d. spell: %s" % [idx, spells[idx]]))

func run():
	pass # cast_spell()

func load_spell_config():
	var config_file = FileAccess.open(spell_config_path, FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		config_file.close()
		spell_config = JSON.parse_string(json_string)
		if not spell_config:
			print("Failed to parse spell_config.json")
		else:
			for spell in spell_config.get("spells"):
				spells.append(spell_constructor.construct_spell(spell))
	else:
		print("Failed to open spell_config.json")
		
func create_spell(spell_name: String) -> Node2D:
	if spell_name in spell_config:
		
		var spell_data = spell_config[spell_name]
		var spell_instance = spell_scene.instantiate()
		spell_instance.spell_data = spell_data
		return spell_instance
	else:
		print("Spell not found: ", spell_name)
		return null

func cast_spell(spell_name: String, start_position: Vector2, direction: Vector2):
	var spell = create_spell(spell_name)
	if spell:
		add_child(spell)
		spell.cast(start_position, direction)

# Usage in main game scene
func _on_player_cast_spell(spell_name: String, start_position: Vector2, direction: Vector2):
	cast_spell(spell_name, start_position, direction)

# List all available spells
func get_available_spells() -> Array:
	return spell_config.keys()

# Get spell data for a specific spell
func get_spell_data(spell_name: String) -> Dictionary:
	return spell_config.get(spell_name, {})
