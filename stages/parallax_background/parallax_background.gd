extends ParallaxBackground

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.NEW:
				scroll_base_offset = Vector2.ZERO
	)

func _process(delta):
	if GameManager.game == GameManager.Game.PLAYING:
		scroll_base_offset += Vector2(-GameManager.speed, 0) * delta
#endregion
