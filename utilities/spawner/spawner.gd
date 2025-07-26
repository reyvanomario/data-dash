class_name Spawner
extends Node2D



const possible_spawn_points: Array[Vector2] = []




@export var node_scene: PackedScene


@export var interval_min: float = 1.0


@export var interval_max: float = 5.0

@export var target_node: Node2D = null

var spawnable_pool: Array[Spawnable] = []

var timer: Timer = Timer.new()

var time_left: float = 0.0




signal finished_spawning(spawn_point: Variant)



func _ready() -> void:
	timer.timeout.connect(on_time_to_spawn)
	add_child(timer)
	
	GameManager.game_changed.connect(func(game: int):
		match game:
			GameManager.Game.PLAYING:
				timer.start(get_time())
			GameManager.Game.OVER, GameManager.Game.NEW:
				timer.stop()
	)
	
	finished_spawning.connect(on_finished_spawning)


func get_time() -> float:
	var interval_divider = GameManager.speed / GameManager.Speed.START
	return randf_range(
		interval_min / interval_divider,
		interval_max / interval_divider
	)


func on_time_to_spawn() -> void:
	timer.stop()
	var spawn_point = SpawnerManager.get_available_spawn_point()
	if spawn_point is not Vector2:
		timer.start(get_time())
		return
	
	spawn(spawn_point)

	finished_spawning.emit(spawn_point)


func on_finished_spawning(spawn_point: Vector2) -> void:
	SpawnerManager.make_spawn_point_available(spawn_point)
	timer.start(get_time())


func get_spawnable_from_node(node: Node) -> Spawnable:
	if node is Spawnable: return node
	for child in node.get_children(true):
		if child is Spawnable: return child
	return null


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


func spawn(spawn_point: Vector2) -> void:

	
	if GameManager.game != GameManager.Game.PLAYING:
		return
	
	var spawnable: Spawnable = add_node_and_get_spawnable()
	if spawnable == null:
		return
	
	spawnable.spawn(spawn_point, target_node)
	
