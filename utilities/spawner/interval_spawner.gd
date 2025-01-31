class_name IntervalSpawner
extends Node2D

@export var obstacle_scenes: Array[PackedScene]

var obstacle_pool: Array[Obstacle] = []

func _ready() -> void:
	GameManager.game_changed.connect(func(game):
		match game:
			GameManager.Game.PLAYING:
				spawn_obstacle()
	)

func get_obstacle() -> Obstacle:
	print(obstacle_pool)
	if obstacle_pool.is_empty():
		var obstacle:Obstacle = obstacle_scenes.pick_random().instantiate()
		add_child(obstacle)
		# setup signal connections
		obstacle.screen_exited.connect(func(): obstacle_pool.append(obstacle))
		return obstacle
	return obstacle_pool.pop_front()

func spawn_obstacle() -> void:
	# wait for some time before doing anything else
	await get_tree().create_timer(2.0).timeout
	# check if movement has stopped before continuing
	if GameManager.game != GameManager.Game.PLAYING:
		return
	
	var obstacle:Obstacle = self.get_obstacle()
	obstacle.position = Vector2(2000, randf_range(100, 1000))
	
	spawn_obstacle()
