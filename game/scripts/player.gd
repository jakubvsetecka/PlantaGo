extends CharacterBody2D

const SPEED = 5000.0
const pi_4 = PI / 4
const pi_2 = PI / 2

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var game = $".."
@onready var joystick = %"Virtual Joystick"
const SPELL = preload ("res://scenes/spell.tscn")

var direction = Vector2.ZERO
var casting = false
var player_rotation = PI/2
var orientation = Vector2(0,1)

func _ready():
	animated_sprite.play("face_down")
	velocity = Vector2(0, 0)

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

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "cast":
		casting = false # Replace with function body.
		

func _on_virtual_joystick_second_touch_pressed():
	cast_spell()
