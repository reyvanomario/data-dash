class_name IntervalSpawner
extends Node2D
## The interval spawner.
##
## Responsible to spawn obstacles in different intervals.

#region VARIABLES
## All obstacle scenes.
@export var obstacle_scenes: Array[PackedScene]
## Coin scene.
@export var coin_scene: PackedScene

## Timer to track distance between intervals
@onready var timer: Timer = $Timer

## The minimum time between obstacles.[br]
## This will decrease while the game speed increases.
var interval_min: float = 1.0
## The maximum time between obstacles.[br]
## This will decrease while the game speed increases.
var interval_max: float = 5.0
## All instantiated but disabled obstacles to be respawned.
var obstacle_pool: Array[Obstacle] = []
#endregion

#region FUNCTIONS
func _ready() -> void:
	# always spawn a new obstacle and restart the timer when the timer reaches the end
	timer.timeout.connect(func(): spawn_obstacle(); start_timer())
	GameManager.game_changed.connect(func(game):
		match game:
			GameManager.Game.PLAYING:
				start_timer()
			GameManager.Game.OVER, GameManager.Game.NEW:
				timer.stop()
	)

## Start the interval timer.
func start_timer():
	var interval_divider = GameManager.speed / GameManager.Speed.START
	var time = randf_range(
		interval_min / interval_divider,
		interval_max / interval_divider
	)
	timer.start(time)

## Get an obstacle, either a newly instantiated or a reusable.
func get_obstacle() -> Obstacle:
	if obstacle_pool.is_empty():
		var obstacle:Obstacle = obstacle_scenes.pick_random().instantiate()
		add_child(obstacle)
		# setup signal connections
		obstacle.disabled.connect(func(): obstacle_pool.append(obstacle))
		return obstacle
	return obstacle_pool.pop_front()

## Spawn or respawn an obstacle.
func spawn_obstacle() -> void:
	# check if movement has stopped before continuing
	if GameManager.game != GameManager.Game.PLAYING:
		return
	
	var obstacle:Obstacle = self.get_obstacle()
	obstacle.enabled = true
#endregion
