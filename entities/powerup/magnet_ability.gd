extends Node2D

var magnet_active: bool = false
@onready var magnet_area = $MagnetArea2D
var collectibles_in_range: Array = []

func _ready() -> void:
	magnet_area.area_entered.connect(on_magnet_area_entered)
	magnet_area.area_exited.connect(on_magnet_area_exited)
	


func _process(delta: float) -> void:
	for collectible in collectibles_in_range:
			if collectible.is_visible:
				var dir = (global_position - collectible.global_position).normalized()
				collectible.velocity += dir * 10000  * delta	


func on_magnet_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("collectibles"):
		collectibles_in_range.append(area.get_parent())
		
		
func on_magnet_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("collectibles"):
		collectibles_in_range.erase(area.get_parent())
		
		
		
