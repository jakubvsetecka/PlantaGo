# HealthBar.gd
extends Control

@onready var progress_bar = $ProgressBar
@onready var parent = get_parent()

func _ready():
	# Ensure the parent has the necessary properties
	assert(parent.has_method("get_health") and parent.has_method("get_max_health"), 
		   "Parent node must have get_health() and get_max_health() methods")
	
	assert(parent.has_method("kill"), "Parent node must have kill() method")
	
	# Set up the progress bar
	update_health_display()

func _process(delta):
	update_health_display()

func update_health_display():
	var health_percentage = (float(parent.get_health()) / parent.get_max_health()) * 100
	if health_percentage <= 0:
		parent.kill()
	progress_bar.value = health_percentage

# HealthBar.tscn
# - Root (Node2D)
#   - ProgressBar
#     (Set the ProgressBar properties in the Inspector:
#      Percent Visible: On
#      Min Value: 0
#      Max Value: 100
#      Step: 1
#      Value: 100)
