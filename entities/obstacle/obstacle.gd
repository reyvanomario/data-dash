class_name Obstacle
extends Area2D
## Base class for player obstacles.

#region VARIABLES
## The collision shape for the obstacle.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
## Used to notify if the obstacle enters or exits the screen.
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

## An array with possible spawn points.
var possible_spawn_points: Array[Vector2] = [Vector2(2000, 0)]
## Used to respawn or disable the obstacle.
var enabled: bool = false :
	set(e):
		if e == enabled:
			return
		
		enabled = e
		
		if enabled:
			spawn()
		else:
			disable()
var speed: int = 0
## Is the game playing and scrolling?
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
#endregion

#region SIGNALS
## Emitted when the obstacle is spawned.
signal spawned
## Emitted when the obstacle is disabled.
signal disabled
## Emitted when the obstacle enters the screen.
signal screen_entered
#endregion

#region FUNCTIONS
func _ready():
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				scrolling = false
			GameManager.Game.NEW:
				scrolling = false
				self.enabled = false
			GameManager.Game.PLAYING:
				scrolling = true
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): self.enabled = false)
	
	body_entered.connect(func(body: Node2D):
		if body is Player:
			GameManager.game = GameManager.Game.OVER
	)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed + speed) * delta

## Used to disable the obstacle.
func disable() -> void:
	visible = false
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	disabled.emit()

## Used to spawn the obstacle.
func spawn() -> void:
	position = possible_spawn_points.pick_random()
	visible = true
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	spawned.emit()
#endregion
