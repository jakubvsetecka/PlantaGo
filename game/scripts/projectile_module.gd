extends SpellModule
class_name ProjectileModule

@export var velocity: float = 200
@export var shape: SpellShape
@export var effect: SpellEffect 

@export var lifetime: float = 5.0

#@onready var sprite: Sprite2D = $Sprite2D
#@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func _ready():
	set_physics_process(false)

func _init(velocity: float, shape: SpellShape, effect: SpellEffect):
	super(shape)
	
	self.velocity = velocity
	self.shape = shape
	self.effect = effect
	# Set up shape, sprite, etc. based on data
	#collision_layer = 2  # Set appropriate layer
	#collision_mask = 1   # Set appropriate mask
	#setup_appearance("#fffff", shape.get(""))
	
func _to_string():
	return "ProjectileModule(velocity: %d, shape: %s, effect: %s, next_mod: %s)" % [velocity, shape, effect, "None" if next_module == null else next_module]

func start(initial_pos: Vector2):
	global_position = initial_pos
	direction = Vector2.RIGHT
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
