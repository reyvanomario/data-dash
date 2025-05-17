class_name HurtboxComponent
extends Area2D

@export var health: int = 1 
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const EXPLOSION_SCENE = preload("res://entities/missile/explosion.tscn")

signal on_hit
signal died


func damage(amount: int = health, audio_stream: AudioStream = null, is_missile = false) -> void:
	on_hit.emit()
	
	owner.life_gui_container.decrementLifes(health)
	health -= amount
	
	if audio_stream != null:
		audio_stream_player_2d.stream = audio_stream
		audio_stream_player_2d.play()
	
	Callable(check_death).call_deferred()
	
	if is_missile:
		var hit_pos = global_position
		
		var expl = EXPLOSION_SCENE.instantiate()
		get_tree().current_scene.add_child(expl)
		
		expl.global_position = hit_pos
		expl.explosion_sprite.play("explode")
		
		await expl.explosion_sprite.animation_finished
		
		expl.queue_free()
		
	
	
	
	#get_node("CollisionShape2D").disabled = true



func check_death():
	if health == 0:
		died.emit()
		


	
