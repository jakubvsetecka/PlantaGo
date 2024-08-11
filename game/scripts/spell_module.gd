extends Node2D

class_name SpellModule

var sprite: Sprite2D
var collision_shape: CollisionShape2D

# var position: Vector2
var next_module: SpellModule

func _init(shape: SpellShape):
	# Create Sprite2D
	sprite = Sprite2D.new()
	add_child(sprite)

	# Create CollisionShape2D
	collision_shape = CollisionShape2D.new()
	add_child(collision_shape)
	
	create_appearance(shape)

func start(direction: Vector2):
	pass

func on_hit(target):
	print("OnHit caught, activating next module...")
	if next_module:
		add_child(next_module)
		next_module.position = position
		next_module.start(Vector2.ZERO)

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
	
	print("Appearance created for shape: " + str(spell_shape))

