class_name Spawner
extends Node2D
## A time interval based spawner.

#region CONSTANTS
## An array of possible spawn points.
const possible_spawn_points: Array[Vector2] = []
#endregion

#region VARIABLES
## Node scene to be instantiated and spawned.
@export var node_scene: PackedScene
## The minimum time between spawnables.[br]
## This will decrease while the game speed increases.
@export var interval_min: float = 1.0
## The maximum time between spawnables.[br]
## This will decrease while the game speed increases.
@export var interval_max: float = 5.0
## The optional target node (to look, aim, follow, etc).
@export var target_node: Node2D = null
## All instantiated but despawned spawnables are collected here.
var spawnable_pool: Array[Spawnable] = []
#endregion

#region SIGNALS
## Emitted when it's time to spawn a new spawnable.
signal time_to_spawn
## Emitted when the spawner just finished spawning.
signal finished_spawning(spawn_point: Variant)
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game: int):
		match game:
			GameManager.Game.PLAYING:
				start_timer()
			GameManager.Game.OVER, GameManager.Game.NEW:
				disconnect_time_to_spawn()
	)
	finished_spawning.connect(on_finished_spawning)

## Start a new one-shot timer.
func start_timer() -> void:
	var timer: SceneTreeTimer = get_new_timer()
	connect_time_to_spawn_to_timer(timer)

## Create and return a new instance of a one-shot timer.
func get_new_timer() -> SceneTreeTimer:
	var interval_divider = GameManager.speed / GameManager.Speed.START
	var time = randf_range(
		interval_min / interval_divider,
		interval_max / interval_divider
	)
	return get_tree().create_timer(time)

## Connect the time_to_spawn signal to the one-shot timer.
func connect_time_to_spawn_to_timer(timer: SceneTreeTimer):
	disconnect_time_to_spawn()
	timer.timeout.connect(func(): time_to_spawn.emit())
	time_to_spawn.connect(on_time_to_spawn)

## Disconnect the time_to_spawn signal.
func disconnect_time_to_spawn():
	if time_to_spawn.is_connected(on_time_to_spawn):
		time_to_spawn.disconnect(on_time_to_spawn)

## What should happen when it's time to spawn?
func on_time_to_spawn() -> void:
	var spawn_point = SpawnerManager.get_available_spawn_point()
	if spawn_point is not Vector2:
		start_timer()
		return
	
	await spawn(spawn_point)
	finished_spawning.emit(spawn_point)

## What should happen when the spawner just finished spawning?
func on_finished_spawning(spawn_point: Vector2) -> void:
	SpawnerManager.make_spawn_point_available(spawn_point)
	start_timer()

## Get spawnable component from node.
func get_spawnable_from_node(node: Node) -> Spawnable:
	if node is Spawnable: return node
	for child in node.get_children(true):
		if child is Spawnable: return child
	return null

## Tries to add the provided scene as a node to the scene tree, and return a spawnable.
func add_node_and_get_spawnable() -> Spawnable:
	var spawnable: Spawnable = spawnable_pool.pop_front()
	if spawnable == null:
		var node: Node = node_scene.instantiate()
		spawnable = get_spawnable_from_node(node)
		if spawnable == null:
			return null
		
		add_child(node)
		spawnable.despawned.connect(func(_new_position: Vector2): spawnable_pool.append(spawnable))
	
	return spawnable

## Spawn the specific spawnable assigned to this spawner.
func spawn(spawn_point: Vector2) -> void:
	# check if movement has stopped before continuing
	if GameManager.game != GameManager.Game.PLAYING:
		return
	
	var spawnable: Spawnable = add_node_and_get_spawnable()
	if spawnable == null:
		return
	
	spawnable.spawn(spawn_point, target_node)
#endregion
