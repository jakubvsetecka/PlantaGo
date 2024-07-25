extends CharacterBody2D

enum Orientation {
	LEFT = 0,
	RIGHT = 1,
	UP = 2,
	DOWN = 3
}

const SPEED = 5000.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var game = $".."
const SPELL = preload ("res://scenes/spell.tscn")

var direction = Vector2.ZERO
var casting = false
var orientation = Orientation.DOWN

func get_direction():
	print("direction is: " + direction)
	return direction

func cast_spell():
	if not casting:
		casting = true
		animated_sprite.play("cast")
		timer.start()

		var spell = SPELL.instantiate()
		match orientation:
			Orientation.LEFT:
				spell.rotation_degrees = 90
				spell.direction = Vector2.LEFT
			Orientation.RIGHT:
				spell.rotation_degrees = -90
				spell.direction = Vector2.RIGHT
			Orientation.UP:
				spell.rotation_degrees = 180
				spell.direction = Vector2.UP
			Orientation.DOWN:
				spell.rotation_degrees = 0
				spell.direction = Vector2.DOWN
		spell.position = position
		game.add_child(spell)

func _on_timer_timeout():
	casting = false
	# Remove this line if you don't want to reload the scene after casting
	# get_tree().reload_current_scene()

func animate_sprite(orientation, is_running):
	if is_running:
		match orientation:
			Orientation.LEFT:
				animated_sprite.play("run_left")
			Orientation.RIGHT:
				animated_sprite.play("run_right")
			Orientation.UP:
				animated_sprite.play("run_up")
			Orientation.DOWN:
				animated_sprite.play("run_down")
	else:
		match orientation:
			Orientation.LEFT:
				animated_sprite.play("face_left")
			Orientation.RIGHT:
				animated_sprite.play("face_right")
			Orientation.UP:
				animated_sprite.play("face_up")
			Orientation.DOWN:
				animated_sprite.play("face_down")

func _input(event):
	if event.is_action_pressed("cast"):
		print("Input received")
		cast_spell()

func _physics_process(delta):

	# Get Input
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	# Normalize the direction to prevent faster diagonal movement
	direction = direction.normalized()

	# Set the velocity
	if direction:
		velocity = direction * SPEED * delta
	else:
		# Stop the character when there's no input
		velocity = Vector2.ZERO

	# Animate the character
	if velocity.y > 0:
		orientation = Orientation.DOWN
	elif velocity.y < 0:
		orientation = Orientation.UP
	elif velocity.x > 0:
		orientation = Orientation.RIGHT
	elif velocity.x < 0:
		orientation = Orientation.LEFT

	if not casting:
		animate_sprite(orientation, velocity != Vector2(0, 0))

	# Move the character
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "cast":
		casting = false # Replace with function body.
