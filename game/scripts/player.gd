class_name Player
extends CharacterBody2D

# Player Attribute
var max_health : int = 100
var health : int = max_health
var damage : int = 10 # Collision damage
@export var knockback_force: float = 50.0
@export var knockback_duration: float = 0.2
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

const SPEED = 2000.0
const pi_4 = PI / 4
const pi_2 = PI / 2

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var game = $".."
@onready var joystick = %"Virtual Joystick"
const SPELL = preload ("res://scenes/spell.tscn")

@export var max_collisions := 6
var collision_count := 0

var direction = Vector2.ZERO
var casting = false
var player_rotation = PI/2
var orientation = Vector2(0,1)

func _ready():
	animated_sprite.play("face_down")

func get_health():
	return health  # Assuming 'health' is a property of the character

func get_max_health():
	return max_health  # Assuming 'max_health' is a property of the character

func kill():
	print("You died")
	get_tree().reload_current_scene()

func get_direction():
	print("direction is: " + direction)
	return direction

func cast_spell():
	if not casting:
		casting = true
		animated_sprite.play("cast")
		timer.start()

		var spell = SPELL.instantiate()
		spell.rotation = player_rotation - pi_2
		spell.direction = orientation
		spell.position = position
		game.add_child(spell)

func _on_timer_timeout():
	casting = false
	# Remove this line if you don't want to reload the scene after casting
	# get_tree().reload_current_scene()

func animate_sprite(is_casting, is_running):
	
	var animation = animated_sprite.animation
	
	# Handle Casting
	if is_casting:
		return
		
	# Handle idle character
	if not is_running:
		if "face" in animation:
			return
		else:
			if (player_rotation < pi_4) and (player_rotation > (-pi_4)):
				animated_sprite.play("face_right")
			elif (player_rotation > pi_4) and (player_rotation < (pi_4 * 3)):
				animated_sprite.play("face_down")
			elif (player_rotation > (-3*pi_4)) and (player_rotation < -pi_4):
				animated_sprite.play("face_up")
			else:
				animated_sprite.play("face_left")
			return
	
	# Handle runninng character
	if is_running:
		if (player_rotation < pi_4) and (player_rotation > (-pi_4)):
			animated_sprite.play("run_right")
		elif (player_rotation > pi_4) and (player_rotation < (pi_4 * 3)):
			animated_sprite.play("run_down")
		elif (player_rotation > (-3*pi_4)) and (player_rotation < -pi_4):
			animated_sprite.play("run_up")
		else:
			animated_sprite.play("run_left")
			
func _input(event):
	if event.is_action_pressed("cast"):
		cast_spell()

func _physics_process(delta):
	# Handle collisions
	collision_count = 0
	var collision = move_and_collide(velocity * delta)
	
	while (collision and collision_count < max_collisions):
		var collider = collision.get_collider()
		
		if collider is Slime:
			collider.hit(damage, position)
			break
		else:
			collision_count += 1

	# Handle knockback
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		move_and_slide()
	else:
		# Get Input
		var joystick_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")

		# Normalize the direction to prevent faster diagonal movement
		direction = joystick_direction
		direction = direction.normalized()
		
		# Set the orientation
		if direction != Vector2(0,0):
			orientation = direction
		
		# Set the velocity
		if direction:
			velocity = direction * SPEED * delta
		else:
			# Stop the character when there's no input
			velocity = Vector2.ZERO
		
		# Get the joysticks rotation
		if joystick and joystick.is_pressed:
			player_rotation = joystick.output.angle()
		
		# Animate the character
		animate_sprite(casting, velocity != Vector2(0,0))

		# Move the character
		move_and_slide()

func hit(value: int, attacker_position: Vector2):
	health -= value
	print("Ow! New health: ", health)
	
	# Calculate knockback direction
	var knockback_direction = (global_position - attacker_position).normalized()
	
	# Apply knockback
	knockback_velocity = knockback_direction * knockback_force
	knockback_timer = knockback_duration

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "cast":
		casting = false # Replace with function body.
		

func _on_virtual_joystick_second_touch_pressed():
	cast_spell()
