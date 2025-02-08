class_name Coin
extends Area2D

#region VARIABLES
## Used to notify if the coin enters or exits the screen.
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

## An array with possible spawn points.
static var possible_spawn_points: Array[Vector2] = [
	Vector2(2000, 120),
	Vector2(2000, 394),
	Vector2(2000, 667),
	Vector2(2000, 940),
]
## The index of one position from all possible positions to spawn at.
var position_index: int = 0 :
	set(i):
		if position_index > possible_spawn_points.size() - 1:
			return
		position_index = i
## Used to respawn or disable the coin.
var enabled: bool = false :
	set(e):
		if e == enabled:
			return
		
		enabled = e
		
		if enabled:
			spawn.call_deferred()
		else:
			disable.call_deferred()
var speed: int = 0
## Is the game playing and scrolling?
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
#endregion

#region SIGNALS
## Emitted when the coin is spawned.
signal spawned
## Emitted when the coin is disabled.
signal disabled
## Emitted when the coin enters the screen.
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
			collected(body)
	)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed + speed) * delta

func collected(player: Player) -> void:
	enabled = false
	GameManager.coins += 1

## Used to disable the coin.
func disable() -> void:
	visible = false
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	disabled.emit()

## Used to spawn the coin.
func spawn() -> void:
	position = possible_spawn_points[position_index]
	visible = true
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	spawned.emit()
#endregion
