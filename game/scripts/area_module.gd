extends SpellModule
class_name AreaModule

@export var ttl: float = 5.0
@export var shape: SpellShape
@export var pos: AreaPosition
@export var effect: SpellEffect

var area: Area2D
var timer: Timer
var tick_timer: Timer

func _init(ttl, shape, position, effect):
	super(shape)
	self.ttl = ttl
	self.shape = shape
	self.pos = position
	self.effect = effect
	
	print("Area: Created")

func _ready():
	# Set up the area
	area = Area2D.new()
	add_child(area)
	
	# Set up collision shape
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape.get_collision_shape()
	area.add_child(collision_shape)
	
	# Set appropriate collision layers and masks
	area.collision_layer = 2  # Adjust as needed
	area.collision_mask = 1   # Adjust as needed
	
	# Set z-index to appear below other nodes
	z_index = 1
	
	# Start the area effect
	start(global_position)

func start(position: Vector2):
	self.global_position = position
	
	# Create and configure the main timer for TTL
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_Timer_timeout)
	timer.start(ttl)
	
	# Create and configure the tick timer
	tick_timer = Timer.new()
	tick_timer.wait_time = 0.5  # Tick twice per second
	tick_timer.one_shot = false
	add_child(tick_timer)
	tick_timer.timeout.connect(_on_tick)
	tick_timer.start()
	
	# Initial tick
	_on_tick()

func _on_tick():
	# print("Ticking")
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		effect.apply_to(body)
		emit_signal("trigger_next_module", mod_chain, body)

func _on_Timer_timeout():
	print("AreaModule lifetime ended")
	queue_free()

func _to_string():
	return "AreaModule(ttl: %d, shape: %s, pos: %s, effect: %s, next_mod: %s)" % [ttl, shape, pos, effect, "None" if next_module == null else next_module]
