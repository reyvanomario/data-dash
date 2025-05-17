class_name MissileSpawner
extends Spawner


func spawn(spawn_point: Vector2) -> void:
	spawn_point = Vector2(2000, target_node.position.y) if target_node != null else spawn_point
	super.spawn(spawn_point)
