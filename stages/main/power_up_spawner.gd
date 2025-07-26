class_name PowerUpSpawner
extends Spawner

@export var fixed_interval_min: float = 20.0
@export var fixed_interval_max: float = 25.0


func get_time() -> float:
	return randf_range(fixed_interval_min, fixed_interval_max)
