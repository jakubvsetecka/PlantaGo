extends CharacterBody2D

@onready var player = %Player
@onready var killzone = $Killzone
const SPEED = 1000  # Increased speed for better movement

func _ready():
	if not player:
		print("Player not found. Check the node path.")

func _physics_process(delta):
	if player:
		# Get direction to player
		var direction = (player.global_position - global_position).normalized()
		
		# Set velocity
		velocity = direction * SPEED * delta
		
		# Move and slide
		move_and_slide()
	else:
		print("Player not found")

func _on_killzone_area_entered(area):
	print("Slime's killzone collided with: ", area.get_parent().name)
	# Handle collision with spell here
	# For example:
	# if area.get_parent().is_in_group("spells"):
	#     queue_free()  # Destroy the slime
