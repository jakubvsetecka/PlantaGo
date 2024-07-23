# Main.gd
extends Node2D

var map_node: Node2D
var player_node: ColorBall
var ui_layer: CanvasLayer
var location_manager: LocationManager

func _ready():
	setup_map()
	setup_player()
	setup_ui()
	setup_location_services()

func setup_map():
	map_node = Node2D.new()
	map_node.name = "Map"
	add_child(map_node)

	# Create a textured background
	var background = TextureRect.new()
	background.name = "TexturedBackground"
	background.set_anchors_preset(Control.PRESET_FULL_RECT) # Make it cover the entire parent

	# Load and set the texture
	var texture = load("res://src/imgs/tiles.jpg") # Replace with your texture path
	background.texture = texture

	# Set texture to repeat
	background.stretch_mode = TextureRect.STRETCH_TILE

	# Add the background to the map
	map_node.add_child(background)

func setup_player():
	player_node = ColorBall.new()
	player_node.name = "Player"
	player_node.radius = 20 # Increased size for visibility
	player_node.color = Color.RED

	# Position the player at the center of the screen
	var screen_size = get_viewport_rect().size
	player_node.position = screen_size / 2

	map_node.add_child(player_node)

	# Debug print
	print("Player added at position: ", player_node.position)

# Add this new class at the end of your script
class ColorBall extends Node2D:
	var radius: float = 20.0
	var color: Color = Color.RED

	func _draw():
		draw_circle(Vector2.ZERO, radius, color)
		# Debug: Draw a small cross at the center for reference
		draw_line(Vector2( - 5, 0), Vector2(5, 0), Color.WHITE, 2)
		draw_line(Vector2(0, -5), Vector2(0, 5), Color.WHITE, 2)

	func _process(_delta):
		queue_redraw() # Ensure the ball is redrawn each frame

# Add this method to your main script for additional debugging
func _process(_delta):
	if player_node:
		print("Player position: ", player_node.global_position)

func setup_ui():
	ui_layer = CanvasLayer.new()
	ui_layer.name = "UI"
	add_child(ui_layer)

	var bottom_panel = Panel.new()
	bottom_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_panel.set_offset(SIDE_TOP, -50) # Adjust this value to set the height of the panel
	ui_layer.add_child(bottom_panel)

	var hbox = HBoxContainer.new()
	hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bottom_panel.add_child(hbox)

	var button_names = ["Game", "Photo", "Inventory"]
	for button_name in button_names:
		var button = Button.new()
		button.text = button_name
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_button_pressed.bind(button_name))
		hbox.add_child(button)

func _on_button_pressed(button_name: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = "Coming soon: " + button_name
	ui_layer.add_child(dialog)
	dialog.popup_centered()

func setup_location_services():
	location_manager = LocationManager.new()
	add_child(location_manager)
	location_manager.location_changed.connect(_on_location_changed)
	location_manager.request_location_permission()
	location_manager.start_location_updates()

func _on_location_changed(location: Dictionary):
	var latitude = location["latitude"]
	var longitude = location["longitude"]
	update_player_position(latitude, longitude)

func update_player_position(latitude: float, longitude: float):
	# Convert GPS coordinates to game world coordinates
	# You'll need to implement your own conversion based on your map system
	var game_x = longitude * 1000 # Example scale factor
	var game_y = latitude * 1000 # Example scale factor
	player_node.position = Vector2(game_x, game_y)
