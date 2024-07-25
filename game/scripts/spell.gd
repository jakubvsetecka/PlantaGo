extends Node2D

var direction = Vector2.ZERO
const SPEED = 90

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == Vector2(0,0):
		pass
	position += direction * SPEED * delta
