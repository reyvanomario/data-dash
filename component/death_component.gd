extends Node2D

@export var hurtbox_component: Node2D
@export var sprite: Sprite2D



func _ready() -> void:
	hurtbox_component.died.connect(on_died)
	
	
func on_died():
	var tween = create_tween().set_parallel(true)
	
	# 3. Animasi fade out sprite
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	
	# 4. Scale down sprite secara progresif
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.3)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	
	# 5. Delay partikel untuk sinkronisasi
	await get_tree().create_timer(0.15).timeout
	
	$AnimationPlayer.play("default")
	
	# 7. Hapus sprite setelah animasi
	await tween.finished
	sprite.visible = false
