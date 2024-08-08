extends SpellModule
class_name AreaModule

@export var ttl: float = 5.0
@export var shape: SpellShape
@export var pos: AreaPosition
@export var effect: SpellEffect


@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var time_alive: float = 0.0

func _ready():
	set_process(false)
	timer.wait_time = self.ttl
	timer.connect("timeout", Callable(self, "_on_tick"))

func _init(ttl, shape, position, effect):
	self.ttl = ttl
	self.shape = shape
	self.pos = position
	self.effect = effect

func start(_direction: Vector2):
	set_process(true)
	timer.start()

func _process(delta):
	time_alive += delta
	if time_alive > ttl:
		queue_free()

func _on_tick():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(5)  # Example damage value
