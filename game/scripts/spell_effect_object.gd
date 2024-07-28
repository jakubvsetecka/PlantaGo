extends Node2D
class_name SpellEffectObject

# Basic attributes
@export var shape: String = "circle"
@export var size: Vector2 = Vector2(100, 100)
@export var ttl: float = 5.0

# Additional attributes for game mechanics
@export_group("Effect")
@export var effect_type: String = "heal"
@export var strength: float = 1.0
@export_group("")

# Node references
var area: Area2D
var collision_shape: CollisionShape2D
var color_rect: ColorRect
var custom_draw: CircleDrawer
var timer: Timer


# Collision mask
@export_flags("Layer 1", "Layer 2", "Layer 3", "Layer 4", "Layer 5") var collision_mask: int = 1

func _ready():
	# Set up the Area2D
	area = Area2D.new()
	add_child(area)
	
	# Set up the collision shape
	collision_shape = CollisionShape2D.new()
	var shape_obj
	
	if shape == "circle":
		shape_obj = CircleShape2D.new()
		shape_obj.radius = size.x / 2
	elif shape == "rectangle":
		shape_obj = RectangleShape2D.new()
		shape_obj.extents = size / 2
	else:
		push_error("Unsupported shape: " + shape)
		return

	collision_shape.shape = shape_obj
	area.add_child(collision_shape)
	area.collision_mask = collision_mask

	# Set up the visual representation
	if shape == "circle":
		custom_draw = CircleDrawer.new()
		custom_draw.set_radius(size.x / 2)
		custom_draw.color = Color.RED
		add_child(custom_draw)
	else:
		color_rect = ColorRect.new()
		color_rect.size = size
		color_rect.color = Color.RED
		color_rect.position = -size / 2
		add_child(color_rect)

	# Set up the timer for TTL
	timer = Timer.new()
	timer.wait_time = ttl
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

	# Connect the area signals
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	print(str(body.name) + " Entered the spell area.")
	apply_effect(body)

func _on_body_exited(body):
	# You can implement logic for when an object exits the effect area
	pass

func apply_effect(target):
	match effect_type:
		"heal":
			if target.has_method("heal"):
				target.heal(strength)
		"damage":
			if target.has_method("hit"):
				target.hit(strength, position)
		"speed_boost":
			if "speed" in target:
				target.speed += strength
		# Add more effect types as needed

class CircleDrawer extends Node2D:
	var _radius: float
	var color: Color = Color.RED

	func set_radius(new_radius: float):
		_radius = new_radius
		queue_redraw()

	func _draw():
		draw_circle(Vector2.ZERO, _radius, color)
