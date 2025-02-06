class_name Coin
extends Area2D

#region VARIABLES
var speed: int = 0
## Is the game playing and scrolling?
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
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
	
	body_entered.connect(func(body: Node2D):
		if body is Player:
			queue_free()
	)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed + speed) * delta
#endregion
