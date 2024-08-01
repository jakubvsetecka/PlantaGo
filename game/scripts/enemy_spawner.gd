extends Node2D

@export var Slime: PackedScene
@export var spawn_radius: float = 1000.0
@export var min_spawn_distance: float = 500.0
@export var max_enemies: int = 10
@export var spawn_interval: float = 2.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $SpawnTimer

var current_enemies = 0

func _ready():
	if not player:
		push_error("Player not found. Make sure the player is in the 'player' group.")
		return
	timer.wait_time = spawn_interval
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	timer.start()

func _on_spawn_timer_timeout():
	if current_enemies < max_enemies:
		spawn_enemy()

func spawn_enemy():
	var spawn_position = get_random_spawn_position()
	var enemy = Slime.instantiate()
	enemy.position = spawn_position
	add_child(enemy)
	if enemy.has_method("set_player"):
		enemy.set_player(player)
	current_enemies += 1
	enemy.connect("tree_exiting", Callable(self, "_on_enemy_killed"))

func get_random_spawn_position() -> Vector2:
	var random_angle = randf() * 2 * PI
	var random_distance = randf_range(min_spawn_distance, spawn_radius)
	var spawn_offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	return player.global_position + spawn_offset

func _on_enemy_killed():
	current_enemies -= 1
