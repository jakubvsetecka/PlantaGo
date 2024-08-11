extends SpellShape

class_name DonutShape

var outer_radius = 0
var inner_radius = 0
var angle = 0
var rotation = 0

func _init(outer, inner, ang, rot):
	outer_radius = outer
	inner_radius = inner
	angle = ang
	rotation = rot

func _to_string():
	return "DonutShape(outer_radius: %d, inner_radius: %d, angle: %d, rotation: %d)" % [outer_radius, inner_radius, angle, rotation]

func get_image(color):
	var size = outer_radius * 2
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))  # Transparent background
	
	var half_angle = deg_to_rad(angle / 2)
	var rot = deg_to_rad(rotation)
	
	for x in range(size):
		for y in range(size):
			var vec = Vector2(x - size/2, y - size/2)
			var distance = vec.length()
			if distance <= outer_radius and distance >= inner_radius:
				var pixel_angle = vec.angle() - rot
				pixel_angle = fmod(pixel_angle + PI, PI * 2) - PI  # Normalize angle
				if abs(pixel_angle) <= half_angle:
					image.set_pixel(x, y, color)
	
	return image
	
func get_collision_shape():
	# For simplicity, we'll use a CircleShape2D with the outer radius
	var shape = CircleShape2D.new()
	shape.radius = outer_radius
	return shape
