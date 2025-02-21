class_name CoinSpawner
extends Spawner

func spawn() -> void:
	spawn_point = possible_spawn_points.pick_random()
	var amount = randi_range(5, 10)
	for c in amount:
		super.spawn()
		var interval_divider = GameManager.speed / GameManager.Speed.START
		await get_tree().create_timer(0.3 / interval_divider).timeout
