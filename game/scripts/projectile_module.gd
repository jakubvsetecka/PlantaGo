extends SpellModule

@export var velocity: float = 200
@export var lifetime: float = 5.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func _ready():
	set_physics_process(false)

func initialize(data: Dictionary):
	velocity = data.get("velocity", velocity)
	# Set up shape, sprite, etc. based on data

func start(new_direction: Vector2):
	direction = new_direction
	set_physics_process(true)

func _physics_process(delta):
	position += direction * velocity * delta
	time_alive += delta
	if time_alive > lifetime:
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)  # Example damage value
	on_hit(body)
	queue_free()
