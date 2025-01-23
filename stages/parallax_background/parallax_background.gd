extends ParallaxBackground

## Is the game playing and scrolling?
var scrolling:bool = false :
	set(s):
		if s == scrolling: return
		scrolling = s

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				scrolling = false
			GameManager.Game.NEW:
				scrolling = false
				scroll_base_offset = Vector2.ZERO
			GameManager.Game.PLAYING:
				scrolling = true
	)

func _process(delta):
	if scrolling:
		scroll_base_offset.x += -GameManager.speed * delta
#endregion
