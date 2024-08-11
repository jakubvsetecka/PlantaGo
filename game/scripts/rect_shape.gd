extends SpellShape

class_name RectShape

var outer_width = 0
var inner_width = 0
var length = 0
var rotation = 0

func _init(outer, inner, len, rot):
	outer_width = outer
	inner_width = inner
	length = len
	rotation = rot
	
func _to_string():
	return "RectShape(outer_width: %d, inner_width: %d, length: %d, rotation: %d)" % [outer_width, inner_width, length, rotation]

func get_image(color):
	var image = Image.create(length, outer_width, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))  # Transparent background
	
	for x in range(length):
		for y in range(outer_width):
			if y >= (outer_width - inner_width) / 2 and y < (outer_width + inner_width) / 2:
				image.set_pixel(x, y, color)
	
	return image

func get_collision_shape():
	var shape = RectangleShape2D.new()
	shape.size = Vector2(length, outer_width)
	return shape
