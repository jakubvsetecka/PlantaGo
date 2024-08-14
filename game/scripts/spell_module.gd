extends Node2D

class_name SpellModule

signal trigger_next_module(mod_chain, target)

var mod_chain: Stack

var sprite: Sprite2D
var area2d: Area2D
var collision_shape: CollisionShape2D

# var position: Vector2
var next_module: SpellModule

func _init(shape: SpellShape):
	# Create Sprite2D
	sprite = Sprite2D.new()
	add_child(sprite)

	# Create Area2D
	area2d = Area2D.new()
	add_child(area2d)

	# Create CollisionShape2D
	collision_shape = CollisionShape2D.new()
	area2d.add_child(collision_shape)
	
	area2d.collision_layer = 2  # Set appropriate layer
	area2d.collision_mask = 1   # Set appropriate mask
	
	create_appearance(shape)
	
	# Connect the body_entered signal
	area2d.connect("body_entered", Callable(self, "_on_body_entered"))

func start(direction: Vector2):
	pass

func enum_to_string(my_enum, enum_value: int) -> String:
	var keys = my_enum.keys()
	if enum_value >= 0 and enum_value < keys.size():
		return keys[enum_value]
	else:
		return "INVALID_ENUM_VALUE"
		
func _to_string():
	return "didnt propagate to children"

func create_appearance(spell_shape: SpellShape, color: Color = Color.WHITE):
	var image: Image = spell_shape.get_image(color)
	var shape: Shape2D = spell_shape.get_collision_shape()

	var texture = ImageTexture.create_from_image(image)
	sprite.texture = texture
	sprite.rotation = spell_shape.rotation
	
	collision_shape.shape = shape
	collision_shape.rotation = spell_shape.rotation
