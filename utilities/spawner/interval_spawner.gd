class_name IntervalSpawner
extends Node2D

@export var obstacle_scenes: Array[PackedScene]

var interval_min: float = 1.0
var interval_max: float = 5.0
var obstacle_pool: Array[Obstacle] = []

func _ready() -> void:
	GameManager.game_changed.connect(func(game):
		match game:
			GameManager.Game.PLAYING:
				wait_before_spawn()
	)

func wait_before_spawn():
	var interval_divider = GameManager.speed / GameManager.Speed.START
	var time = randf_range(
		interval_min / interval_divider,
		interval_max / interval_divider
	)
	await get_tree().create_timer(time).timeout
	spawn_obstacle()

func get_obstacle() -> Obstacle:
	if obstacle_pool.is_empty():
		var obstacle:Obstacle = obstacle_scenes.pick_random().instantiate()
		add_child(obstacle)
		# setup signal connections
		obstacle.disabled.connect(func(): obstacle_pool.append(obstacle))
		return obstacle
	return obstacle_pool.pop_front()

func spawn_obstacle() -> void:
	# check if movement has stopped before continuing
	if GameManager.game != GameManager.Game.PLAYING:
		return
	
	var obstacle:Obstacle = self.get_obstacle()
	obstacle.enabled = true
	
	wait_before_spawn()
