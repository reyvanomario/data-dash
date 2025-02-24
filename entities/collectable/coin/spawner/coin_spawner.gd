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

func spawn(spawn_point: Vector2) -> void:
	var amount = randi_range(5, 10)
	for c in amount:
		super.spawn(spawn_point)
		var interval_divider = GameManager.speed / GameManager.Speed.START
		between_coins_timer.start(0.3 / interval_divider)
		await between_coins_timer.timeout
#endregion
