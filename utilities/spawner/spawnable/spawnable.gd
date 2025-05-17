class_name Spawnable
extends Node2D


var root_node: Node2D = self

var is_spawned: bool = false :
	set(s):
		if s == is_spawned:
			return
		is_spawned = s

var target: Node2D = null :
	set(t):
		if t == target:
			return
		target = t




signal spawned(spawn_point: Vector2, target_node: Node2D)

signal despawned(new_position: Vector2)



func spawn(spawn_point: Vector2 = Vector2.ZERO, target_node: Node2D = null) -> void:
	if is_spawned:
		return
	
	target = target_node
	root_node.visible = true
	root_node.process_mode = ProcessMode.PROCESS_MODE_INHERIT
	root_node.position = spawn_point
	
	
	is_spawned = true
	spawned.emit(spawn_point, target)
	
	


func despawn(new_position: Vector2 = Vector2.ZERO) -> void:
	if !is_spawned:
		return
	
	root_node.visible = false
	root_node.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	root_node.position = new_position
	is_spawned = false
	despawned.emit(new_position)
	
	# pick random ulang powerup
	if get_parent().is_in_group("powerup"):
		get_parent().pick_powerup()
