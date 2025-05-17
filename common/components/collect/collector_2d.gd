class_name Collector2D
extends Area2D

@export var collectable_identifiers: Array[String] = []

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	area_entered.connect(on_area_entered)
	


func on_area_entered(other_area: Area2D):
	if other_area is Collectable2D:
		if other_area.get_parent().is_in_group("powerup"):
			var player = get_tree().get_first_node_in_group("player")
			player.power_up_collected.emit()
			
		if other_area.identifier in collectable_identifiers:
			other_area.collect()
			play_audio(other_area)
			
			if other_area.get_parent().is_in_group("coin"):
				get_parent().coin_collected.emit()
				
			
				
				
				


func play_audio(collectable: Collectable2D) -> void:
	audio_stream_player_2d.stream = collectable.get_audio()
	if audio_stream_player_2d.stream != null:
		audio_stream_player_2d.play()
