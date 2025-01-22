class_name Player
extends CharacterBody2D
## The main script for the player.

## All exact running speed values/steps.
## While running, the actual running speed will increment from [param START] up to [param MAX] by [param STEP] * delta each frame.
enum Speed {
	RESET = 0,
	STEP = 10,
	START = 400,
	MAX = 2000,
}

#region CONSTANTS
## How much the force is increasing every frame * delta when the jetpack is activated.
const JETPACK_FORCE_INCREMENT_STEP:int = 4000
## Highest amount of force for the jetpack.
const JETPACK_MAX_FORCE:int = 5000
## Highest fall speed.
const MAX_FALL_SPEED = 1200
#endregion

#region VARIABLES
## Basic jetpack particles.
@onready var bullet_particles: GPUParticles2D = $bullet_particles

## Is the player running?[br]
## If [param true]: [member velocity][param .x] will be set to [enum Speed][param .START].[br]
## If [param false]: [member velocity][param .x] will be set to [enum Speed][param .RESET].
var is_running:bool = false :
	set(r):
		is_running = r
		if is_running:
			velocity.x = Speed.START
		else:
			velocity.x = Speed.RESET
## Current jetpack force applied.[br]
## Can only be set between [param 0] and [constant JETPACK_MAX_FORCE].[br]
## It will be set to [param 0] if [member jetpack_activated] is set to [param false].
var jetpack_force:float = 0 :
	set(f):
		if f < 0 or f > JETPACK_MAX_FORCE:
			return
		jetpack_force = f
## Is the jetpack on?[br]
## If [param true]: [member jetpack_force] will be applied to the velocity, and [member bullet_particles] will start emitting particles.[br]
## If [param false]: [member jetpack_force] will be set to [param 0].
var jetpack_activated:bool = false :
	set(a):
		jetpack_activated = a
		bullet_particles.emitting = jetpack_activated
		if not jetpack_activated:
			jetpack_force = 0
var grounded:bool = false
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.NEW:
				reset()
			GameManager.Game.PLAYING:
				is_running = true
	)

func _process(delta: float) -> void:
	if Input.is_action_pressed('fly'):
		jetpack_force += JETPACK_FORCE_INCREMENT_STEP * delta
	if Input.is_action_just_pressed('fly'):
		jetpack_activated = true
	if Input.is_action_just_released('fly'):
		jetpack_activated = false

func _physics_process(delta: float) -> void:
	if is_running and velocity.x < Speed.MAX:
		velocity.x += Speed.STEP * delta
	
	grounded = is_on_floor()
	
	if jetpack_activated:
		velocity.y = -jetpack_force
	if !jetpack_activated and not is_on_floor() and velocity.y < MAX_FALL_SPEED:
		velocity.y += get_gravity().y * delta

	move_and_slide()

## Reset the player.[br]
## Triggered by the [signal GameManagerGlobal.game] signal when set to [enum GameManagerGlobal.Game][param .NEW].
func reset():
	is_running = false
	velocity = Vector2.ZERO
	bullet_particles.restart()
	jetpack_activated = false
	position = Vector2(-50, 940)
#endregion
