extends CharacterBody2D

const JETPACK_FORCE = -15000.0

@onready var player_animation_tree: PlayerAnimationTree = $PlayerAnimationTree

func _physics_process(delta: float) -> void:
	player_animation_tree.grounded = is_on_floor()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed('fly'):  
		player_animation_tree.jetpack_activated = true
		velocity.y += (JETPACK_FORCE * delta)
	if Input.is_action_just_released('fly'):
		player_animation_tree.jetpack_activated = false

	move_and_slide()
