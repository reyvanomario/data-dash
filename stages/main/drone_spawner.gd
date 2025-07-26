class_name DroneSpawner
extends Spawner


@export var base_interval_min: float = 5.0  # Interval minimum dasar
@export var base_interval_max: float = 10.0  # Interval maksimum dasar
@export var interval_multiplier: float = 1.5 


var distance_threshold: float = 40.0
var drones_per_group: int = 1
var max_drones_per_group: int = 4
var next_threshold: float = 40.0

	
	
func spawn(spawn_point: Vector2) -> void:	
	if GameManager.distance >= next_threshold:
		# ga nambahin lagi klo udh max
		if drones_per_group < max_drones_per_group:
			drones_per_group += 1
			next_threshold += distance_threshold
			
			interval_min = base_interval_min * pow(interval_multiplier, drones_per_group - 1)
			interval_max = base_interval_max * pow(interval_multiplier, drones_per_group - 1)
		
		
	var drones_to_spawn = randi_range(1, drones_per_group)
	var screen_height = get_viewport().get_visible_rect().size.y
	
	# Spawn grup drone
	for i in drones_to_spawn:		
		#print("spawn drone")
		var random_y = randf_range(screen_height * 0.2, screen_height * 0.8)
		
		var adjusted_spawn = Vector2(2000,random_y)
		
		super.spawn(adjusted_spawn)
		
