extends SpellModule
class_name AreaModule

@export var ttl: float = 5.0
@export var shape: SpellShape
@export var pos: AreaPosition
@export var effect: SpellEffect


@onready var area: Area2D = $Area2D
var timer: Timer

var time_alive: float = 0.0

func _ready():
	set_process(false)
	timer = Timer.new()
	timer.wait_time = self.ttl
	timer.connect("timeout", Callable(self, "_on_tick"))

func _init(ttl, shape, position, effect):
	super(shape)
	self.ttl = ttl
	self.shape = shape
	self.pos = position
	self.effect = effect
	self.timer = Timer.new()

func _to_string():
	return "AreaModule(ttl: %d, shape: %s, pos: %s, effect: %s, next_mod: %s)" % [ttl, shape, pos, effect, "None" if next_module == null else next_module]

func start(position: Vector2):
	set_process(true)
	self.position = position
	#timer.start()

func _process(delta):
	print("time alive: " + str(time_alive) + " ttl: " + str(ttl))
	time_alive += delta
	if time_alive > ttl:
		queue_free()

func _on_tick():
	print("ticking")
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(5)  # Example damage value
