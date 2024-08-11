class_name Slime
extends CharacterBody2D

var player: Node2D  # Changed from @onready to a regular variable

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
	velocity = Vector2.ZERO
	add_to_group("enemies")
	player = %Player

func set_player(new_player: Node2D):
	player = new_player

func _physics_process(delta):
	
	# Handle Collisions
	collision_count = 0
	var collision = move_and_collide(velocity * delta)
	
	while (collision and collision_count < max_collisions):
		var collider = collision.get_collider()
		
		if collider is Player:
			collider.hit(damage, position)
			break
		else:
			collision_count += 1
	
	# Handle knockback
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		move_and_slide()
	elif player:  # Check if player is set
		# Get direction to player
		var direction = (player.global_position - global_position).normalized()
		
		# Set velocity
		velocity = direction * speed * delta
		
		# Move and slide
		move_and_slide()
	else:
		print("Player not set for this Slime")
		
func hit(value: int, attacker_position: Vector2):
	health -= value
	#print("ASLDnnka;AKSNCKn")
	
	# Calculate knockback direction
	var knockback_direction = (global_position - attacker_position).normalized()
	
	# Apply knockback
	knockback_velocity = knockback_direction * knockback_force
	knockback_timer = knockback_duration
	
func kill():
	emit_signal("tree_exiting")
	queue_free()
	
func get_health():
	return health
	
func get_max_health():
	return max_health
	
