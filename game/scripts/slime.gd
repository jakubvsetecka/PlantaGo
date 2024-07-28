class_name Slime
extends CharacterBody2D

@onready var player = %Player

# Slime atributes
@export var speed = 1000  # Increased speed for better movement
@export var damage : int = 10
@export var max_health : int = 20
var health : int = max_health

@export var knockback_force: float = 50.0
@export var knockback_duration: float = 0.2
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

@export var max_collisions := 6
var collision_count := 0

func _ready():
	if not player:
		print("Player not found. Check the node path.")
	velocity = Vector2.ZERO

func _physics_process(delta):
	# Handle collisions
	collision_count = 0
	var collision = move_and_collide(velocity * delta)
	
	while (collision and collision_count < max_collisions):
		var collider = collision.get_collider()
		
		if collider is Player:
			collider.hit(damage, position)
			break
		else:
			collision_count += 1
	
	# Hnadle knockback
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		move_and_slide()
	else:
		if player:
			# Get direction to player
			var direction = (player.global_position - global_position).normalized()
			
			# Set velocity
			velocity = direction * speed * delta
			
			# Handle collisions
			
			# Move and slide
			move_and_slide()
		else:
			print("Player not found")
		
func hit(value: int, attacker_position: Vector2):
	health -= value
	print("ASLDnnka;AKSNCKn")
	
	# Calculate knockback direction
	var knockback_direction = (global_position - attacker_position).normalized()
	
	# Apply knockback
	knockback_velocity = knockback_direction * knockback_force
	knockback_timer = knockback_duration
	
func kill():
	queue_free()
	
func get_health():
	return health
	
func get_max_health():
	return max_health
	
