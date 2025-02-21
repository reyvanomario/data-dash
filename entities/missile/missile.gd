class_name Missile
extends Node2D
## A flying missile, acting as an obstacle for the player.

#region VARIABLES
## Used to spawn and despawn the missile.
@onready var spawnable: Spawnable = $Spawnable
## Used to notify if the missile enters or exits the screen.
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

## The speed of the missile.
var speed: int = 1000
## Is the game playing and scrolling?
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
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
				scrolling = false
			GameManager.Game.NEW:
				scrolling = false
				spawnable.despawn.call_deferred()
			GameManager.Game.PLAYING:
				scrolling = true
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable.despawn.call_deferred())
	
	spawnable.root_node = self

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed - speed) * delta
#endregion
