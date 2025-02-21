class_name MissileSpawner
extends Spawner
## A time interval based spawner for missiles.

#region VARIABLES
## The target node to aim at.
@export var target_node: Node2D
#endregion

#region FUNCTIONS
func spawn() -> void:
	spawn_point = Vector2(2000, target_node.position.y) if target_node != null else spawn_point
	super.spawn()
#endregion
