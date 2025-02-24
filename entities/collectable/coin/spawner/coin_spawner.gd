class_name CoinSpawner
extends Spawner
## A time interval based spawner for missiles.

#region VARIABLES
## Used to spawn coins spaced out.
var between_coins_timer: Timer = Timer.new()
#endregion

#region FUNCTIONS
func _ready() -> void:
	super._ready()
	add_child(between_coins_timer)

func on_time_to_spawn() -> void:
	timer.stop()
	var spawn_point = SpawnerManager.get_available_spawn_point()
	if spawn_point is not Vector2:
		timer.start(get_time())
		return
	
	var amount = randi_range(5, 10)
	for c in amount:
		var interval_divider = GameManager.speed / GameManager.Speed.START
		between_coins_timer.start(0.3 / interval_divider)
		spawn(spawn_point)
		await between_coins_timer.timeout
	
	finished_spawning.emit(spawn_point)
#endregion
