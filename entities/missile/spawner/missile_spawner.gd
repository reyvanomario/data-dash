class_name MissileSpawner
extends Spawner

var distance_threshold: float = 50.0
var missiles_per_group: int = 1
var max_missiles_per_group: int = 4
var next_threshold: float = 50.0
@export var missile_spawn_delay: float = 0.7
@export var base_interval_min: float = 5.0  # Interval minimum dasar
@export var base_interval_max: float = 12.0  # Interval maksimum dasar
@export var interval_multiplier: float = 1.5 
	
	

func spawn(spawn_point: Vector2) -> void:	
	if GameManager.distance >= next_threshold:
		# ga nambahin lagi klo udh max
		if missiles_per_group < max_missiles_per_group:
			missiles_per_group += 1
			next_threshold += distance_threshold
			
			interval_min = base_interval_min * pow(interval_multiplier, missiles_per_group - 1)
			interval_max = base_interval_max * pow(interval_multiplier, missiles_per_group - 1)
		
		
	
	var missiles_to_spawn = randi_range(1, missiles_per_group)
	
	
	# Spawn grup missile
	for i in missiles_to_spawn:
		print("missile")
		spawn_point = Vector2(2000, target_node.position.y) if target_node != null else spawn_point
		super.spawn(spawn_point)
		
		await get_tree().create_timer(missile_spawn_delay).timeout
