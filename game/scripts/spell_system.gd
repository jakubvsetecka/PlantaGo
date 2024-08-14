extends Node

@export var spell_config_path: String = "res://configs/spells.json"

var spell_config: Dictionary
var spell_scene: PackedScene = preload("res://scenes/Spell.tscn")
var spells: Array = []
var current_spell: int = 0

@onready var spell_timer = $SpellTimer
@onready var player = %Player

func _ready():
	load_spell_config()
	run()
	# print(self)
	
func _to_string() -> String:
	return "\n".join(range(spells.size()).map(func(idx): return "%d. spell: %s" % [idx, spells[idx]]))

func run():
	spell_timer.start()
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
				spells.append(spell)
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

func cast_spell():
	var spell: Spell = GlobalSpellConstructor.construct_spell(spells[current_spell])
	if spell:
		print("Spell constructed")
		add_child(spell)
		spell.cast(player.position)

# Usage in main game scene
#func _on_player_cast_spell(spell_name: String, start_position: Vector2, direction: Vector2):
#	cast_spell(spell_name, start_position, direction)

# List all available spells
func get_available_spells() -> Array:
	return spell_config.keys()

# Get spell data for a specific spell
func get_spell_data(spell_name: String) -> Dictionary:
	return spell_config.get(spell_name, {})

func _on_spell_timer_timeout():
	cast_spell()
	spell_timer.start()
	pass # Replace with function body.
