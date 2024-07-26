extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Player/Camera2D

var direction = Vector2.ZERO
var SPEED = 45

func _ready():
	load_config()

func load_config():
	var config_file = FileAccess.open("res://configs/spell_config.json", FileAccess.READ)
	if config_file:
		var json_string = config_file.get_as_text()
		config_file.close()
		var json = JSON.parse_string(json_string)
		if json:
			SPEED = json.get("speed", SPEED)  # Use default if not found in JSON
		else:
			print("Failed to parse spell_config.json")
	else:
		print("Failed to open spell_config.json")

func get_camera_viewport_rect() -> Rect2:
	camera = get_node("/root/Game/Player/Camera2D")
	var screen_center = camera.get_screen_center_position()
	var viewport_size = get_viewport_rect().size
	var top_left = screen_center - viewport_size / 2
	return Rect2(top_left, viewport_size)

func is_outside_viewport() -> bool:
	var camera_rect = get_camera_viewport_rect()
	return not camera_rect.has_point(global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if direction == Vector2(0,0):
		pass
	position += direction * SPEED * delta
	
	# Check if spell is outside viewport
	if is_outside_viewport():
		print("Spell outside vieport")
		queue_free()
	
	# Play animation
	animated_sprite.play("default")


func _on_area_2d_body_entered(body):
	print("Collided with: ", body.name)
	
	# Destroy the thing it collided with
	body.queue_free()
	
	# Destroy spell after collision
	queue_free()
	
