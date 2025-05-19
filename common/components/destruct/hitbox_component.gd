class_name HitboxComponent
extends Area2D

## The audio streams to choose from when hitting a destructable.
@export var audio_streams: Array[AudioStream] = []
@export var explosion_animated_sprite: AnimatedSprite2D

@export var damage_amount: int = 1


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	area_entered.connect(on_area_entered)

	
func on_area_entered(other_area: Area2D):
	var is_missile = false
	
	if other_area is HurtboxComponent:
		if get_parent().name == "Missile":
			is_missile = true
		
		print(damage_amount)
		other_area.damage(1, get_audio(), is_missile)
		
		
		
		
		

func get_audio() -> AudioStream:
	if audio_streams.is_empty():
		return null
	return audio_streams.pick_random()
