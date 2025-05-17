extends Node

@export var magnet_ability: PackedScene

@onready var magnet_timer: Timer = $MagnetTimer


var magnet_instance: Node2D


func _ready() -> void:
	magnet_timer.timeout.connect(on_magnet_timer_timeout)


func activate_magnet():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	magnet_instance = magnet_ability.instantiate() as Node2D
	player.add_child(magnet_instance)
	magnet_instance.global_position = player.global_position

	player.magnet_active = true
	
	magnet_timer.start()
	
	
func on_magnet_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	player.magnet_active = false
	
	if magnet_instance and magnet_instance.is_inside_tree():
		magnet_instance.queue_free()
		magnet_instance = null
