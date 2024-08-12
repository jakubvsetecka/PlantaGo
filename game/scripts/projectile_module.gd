extends SpellModule
class_name ProjectileModule

@export var velocity: float = 200
@export var shape: SpellShape
@export var effect: SpellEffect 

@export var lifetime: float = 5.0

var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func _ready():
	set_physics_process(false)

func _init(velocity: float, shape: SpellShape, effect: SpellEffect):
	super(shape)
	
	self.velocity = velocity
	self.shape = shape
	self.effect = effect
	
func _to_string():
	return "ProjectileModule(velocity: %d, shape: %s, effect: %s, next_mod: %s)" % [velocity, shape, effect, "None" if next_module == null else next_module]

func find_closest_enemy_direction() -> Vector2:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var closest_distance = INF

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	if closest_enemy:
		return (closest_enemy.global_position - global_position).normalized()
	else:
		return Vector2.ZERO  # Default direction if no enemies are found

func start(initial_pos: Vector2):
	global_position = initial_pos
	direction = find_closest_enemy_direction()
	if direction == Vector2.ZERO:
		queue_free()
	set_physics_process(true)

func _physics_process(delta):
	position += direction * velocity * delta
	time_alive += delta
	if time_alive > lifetime:
		queue_free()

func _on_body_entered(body):
	print("Projectile entered body")
	if body.has_method("hit"):
		body.hit(10, position)  # Example damage value
	
	if body:
		on_hit(body)
	queue_free()
