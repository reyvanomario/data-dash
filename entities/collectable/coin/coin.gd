class_name Coin
extends Area2D

#region VARIABLES
## Used to notify if the coin enters or exits the screen.
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
## Used to spawn and despawn the coin.
@onready var spawnable: Spawnable = $Spawnable

## An array with possible spawn points. 
var speed: int = 0
## Is the game playing and scrolling?
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
#endregion

#region SIGNALS
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
				spawnable.despawn.call_deferred()
			GameManager.Game.PLAYING:
				scrolling = true
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable.despawn.call_deferred())
	
	spawnable.root_node = self
	
	body_entered.connect(func(body: Node2D):
		if body is Player:
			collected(body)
	)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed + speed) * delta

func collected(_player: Player) -> void:
	GameManager.coins += 1
	spawnable.despawn.call_deferred()
#endregion
