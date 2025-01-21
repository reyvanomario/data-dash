extends Control

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.NEW:
				visible = true
			GameManager.Game.PLAYING:
				visible = false
	)
#endregion
