extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	print("You Died!")
	Engine.time_scale = 0.5
	timer.start()
	body.get_node("PlayerShape").queue_free()
	# Print information about the colliding body
	print("Collided with: ", body.name)

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
