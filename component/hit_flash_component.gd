extends Node

@export var hurtbox_component: Node2D
@export var sprite: Sprite2D

@export var hit_flash_material: ShaderMaterial
var hit_flash_tween: Tween

func _ready() -> void:
	hurtbox_component.on_hit.connect(on_hit)
	sprite.material = hit_flash_material
	
	
func on_hit():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.2)
	
