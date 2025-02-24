class_name Missile
extends Node2D
## A flying missile, acting as an obstacle for the player.

#region VARIABLES
## Used to spawn and despawn the missile.
@onready var spawnable: Spawnable = $Spawnable
## Used to notify if the missile enters or exits the screen.
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var warning_animation_sprite: AnimatedSprite2D = $warning_animation_sprite

## Is the missile aiming?
var aiming: bool = true
## The speed of the missile.
var speed: int = 1000
## Is the game playing and scrolling?
var scrolling:bool = false :
	set(s):
		if s == scrolling: return
		scrolling = s
## The target node to aim for.
var target: Node2D = null
## The time for displaying the first warning.
var warning_time_low: float = 2.0
## The time for displaying the last warning.
var warning_time_high: float = 1.0
#endregion

#region SIGNALS
## Emitted when the missile enters the screen.
signal screen_entered
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				aiming = false
				scrolling = false
			GameManager.Game.NEW:
				aiming = false
				scrolling = false
				spawnable.despawn.call_deferred()
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable.despawn.call_deferred())
	
	spawnable.root_node = self
	spawnable.spawned.connect(on_spawned)
	spawnable.despawned.connect(on_despawned)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed - speed) * delta
	if aiming and target != null:
		position.y = lerpf(position.y, target.position.y, 0.1)

## Custom functionality when a missile is spawned.
func on_spawned(_spawn_point: Vector2, target_node: Node2D) -> void:
	target = target_node
	await get_tree().create_timer(warning_time_low).timeout
	
	if GameManager.game == GameManager.Game.OVER:
		return
	
	warning_animation_sprite.animation = 'warning_high'
	await get_tree().create_timer(warning_time_high).timeout
	
	if GameManager.game == GameManager.Game.OVER:
		return
	
	warning_animation_sprite.visible = false
	aiming = false
	scrolling = true

## Custom functionality when a missile is despawned.
func on_despawned(_new_position: Vector2) -> void:
	aiming = true
	scrolling = false
	warning_animation_sprite.animation = 'warning_low'
	warning_animation_sprite.visible = true
#endregion
