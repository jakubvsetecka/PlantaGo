extends Node2D

@onready var player = %Player

const SPEED = 5
var direction = Vector2.ZERO

func _ready():
	if not player:
		print("Player not found. Check the node path.")

func _process(delta):
	if player:
		# Get player position
		var player_position = player.global_position
		
		# Calculate direction to player
		direction = (player_position - global_position).normalized()
		
		# Move towards player
		position += direction * SPEED * delta
	else:
		print("Player not found")
