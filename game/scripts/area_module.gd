extends SpellModule

@export var duration: float = 5.0
@export var tick_interval: float = 1.0

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var time_alive: float = 0.0

func _ready():
	set_process(false)
	timer.wait_time = tick_interval
	timer.connect("timeout", Callable(self, "_on_tick"))

func initialize(data: Dictionary):
	duration = data.get("ttl", duration)
	# Set up shape, sprite, etc. based on data

func start(_direction: Vector2):
	set_process(true)
	timer.start()

func _process(delta):
	time_alive += delta
	if time_alive > duration:
		queue_free()

func _on_tick():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(5)  # Example damage value
