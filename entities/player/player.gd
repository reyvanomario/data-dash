class_name Player
extends CharacterBody2D

#region CONSTANTS
const JETPACK_FORCE_AMPLIFIER:int = 4000
const JETPACK_MAX_FORCE:int = 5000
const MAX_FALL_SPEED = 1200
#endregion

#region VARIABLES
var jetpack_force:float = 0 :
	set(f):
		if f < 0 or f > JETPACK_MAX_FORCE:
			return
		jetpack_force = f
var jetpack_activated:bool = false :
	set(a):
		jetpack_activated = a
		if not jetpack_activated:
			jetpack_force = 0
var grounded:bool = false
#endregion

#region FUNCTIONS
func _process(delta: float) -> void:
	if Input.is_action_pressed('fly'):
		jetpack_force += JETPACK_FORCE_AMPLIFIER * delta
	if Input.is_action_just_pressed('fly'):
		jetpack_activated = true
	if Input.is_action_just_released('fly'):
		jetpack_activated = false

func _physics_process(delta: float) -> void:
	grounded = is_on_floor()
	
	if jetpack_activated:
		velocity.y = -jetpack_force
	elif not is_on_floor() and velocity.y < MAX_FALL_SPEED:
		velocity.y += get_gravity().y * delta

	move_and_slide()
#endregion
