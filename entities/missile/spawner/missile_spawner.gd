class_name MissileSpawner
extends Spawner

var distance_threshold: float = 75.0
var missiles_per_group: int = 1
var next_threshold: float = 75.0
@export var missile_spawn_delay: float = 0.7
@export var base_interval_min: float = 5.0  # Interval minimum dasar
@export var base_interval_max: float = 12.0  # Interval maksimum dasar
@export var interval_multiplier: float = 1.5 


#func _ready() -> void:
	#interval_min = base_interval_min
	#interval_max = base_interval_max
	
	

func spawn(spawn_point: Vector2) -> void:
	#spawn_point = Vector2(2000, target_node.position.y) if target_node != null else spawn_point
	#super.spawn(spawn_point)
	
	# Cek jarak tempuh pemain
	if GameManager.distance >= next_threshold:
		missiles_per_group += 1
		next_threshold += distance_threshold
		
		interval_min = base_interval_min * pow(interval_multiplier, missiles_per_group - 1)
		interval_max = base_interval_max * pow(interval_multiplier, missiles_per_group - 1)
	
	# Spawn grup missile
	for i in missiles_per_group:
		var adjusted_spawn = Vector2(
			2000,
			target_node.position.y + (i * 50 - 100) # Spread vertikal
		) if target_node != null else spawn_point
		
		super.spawn(adjusted_spawn)
		
		await get_tree().create_timer(missile_spawn_delay).timeout
