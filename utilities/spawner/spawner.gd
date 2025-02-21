class_name Spawner
extends Node2D

#region CONSTANTS
## An array of possible spawn points.
const possible_spawn_points: Array[Vector2] = [
	Vector2(2000, 120),
	Vector2(2000, 325),
	Vector2(2000, 530),
	Vector2(2000, 735),
	Vector2(2000, 940),
]
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
## All instantiated but despawned spawnables are collected here.
var spawnable_pool: Array[Spawnable] = []
## Spawn point is either set to a Vector2 or null.
## If null, a random Vector2 from possible_spawn_points will be returned.
var spawn_point: Variant = null :
	set(s):
		if s != null and s is not Vector2:
			return
		spawn_point = s
	get():
		if spawn_point is Vector2:
			return spawn_point
		return possible_spawn_points.pick_random()
#endregion

#region SIGNALS
signal time_to_spawn
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
	time_to_spawn.connect(on_timeout)

## Disconnect the time_to_spawn signal.
func disconnect_time_to_spawn():
	if time_to_spawn.is_connected(on_timeout):
		time_to_spawn.disconnect(on_timeout)

## What should happen when a one-shot timer runs out?
func on_timeout() -> void:
	await spawn()
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
func spawn() -> void:
	# check if movement has stopped before continuing
	if GameManager.game != GameManager.Game.PLAYING:
		return
	
	var spawnable: Spawnable = add_node_and_get_spawnable()
	if spawnable == null:
		return
	
	spawnable.spawn(spawn_point)
#endregion
