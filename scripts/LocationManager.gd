# LocationManager.gd
class_name LocationManager
extends Node

signal location_changed(location)

var is_tracking: bool = false
var mock_latitude: float = 0.0
var mock_longitude: float = 0.0
var update_interval: float = 0.1 # Update every second

func _ready():
    # Initialize with a random location
    mock_latitude = 0.4
    mock_longitude = 0.5

func request_location_permission():
    # Mock implementation always succeeds
    print("Location permission granted (mock)")

func start_location_updates():
    is_tracking = true
    _update_mock_location()

func stop_location_updates():
    is_tracking = false

func _update_mock_location():
    while is_tracking:
        # Simulate small changes in location
        mock_latitude += randf_range( - 0.01, 0.01)
        mock_longitude += randf_range( - 0.01, 0.01)

        # Clamp values to valid ranges
        #mock_latitude = clamp(mock_latitude, -90, 90)
        #mock_longitude = clamp(mock_longitude, -180, 180)

        emit_signal("location_changed", {"latitude": mock_latitude, "longitude": mock_longitude})

        # Wait for the update interval
        await get_tree().create_timer(update_interval).timeout

func get_location_service_status() -> bool:
    return true # Mock implementation always returns true