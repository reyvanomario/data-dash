extends CharacterBody2D

const JETPACK_FORCE_AMPLIFIER:int = 4000
const JETPACK_MAX_FORCE:int = 5000
const MAX_FALL_SPEED = 1200

@onready var player_animation_tree: PlayerAnimationTree = $PlayerAnimationTree

var jetpack_force:float = 0

func _process(delta: float) -> void:
	if Input.is_action_pressed('fly') and jetpack_force < JETPACK_MAX_FORCE:
		jetpack_force += JETPACK_FORCE_AMPLIFIER * delta
	if Input.is_action_just_pressed('fly'):
		player_animation_tree.jetpack_activated = true
	if Input.is_action_just_released('fly'):
		jetpack_force = 0
		player_animation_tree.jetpack_activated = false

func _physics_process(delta: float) -> void:
	player_animation_tree.grounded = is_on_floor()
	
	if jetpack_force > 0:
		velocity.y = -jetpack_force
	elif not is_on_floor() and velocity.y < MAX_FALL_SPEED:
		velocity.y += get_gravity().y * delta

	move_and_slide()
