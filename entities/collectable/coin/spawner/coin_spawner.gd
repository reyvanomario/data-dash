class_name CoinSpawner
extends Spawner

func spawn(spawn_point: Vector2) -> void:
	var amount = randi_range(5, 10)
	for c in amount:
		super.spawn(spawn_point)
		var interval_divider = GameManager.speed / GameManager.Speed.START
		await get_tree().create_timer(0.3 / interval_divider).timeout
