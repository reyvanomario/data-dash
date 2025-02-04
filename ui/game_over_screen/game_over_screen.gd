extends Control

#region VARIABLES
@onready var restart_button: Button = $VBoxContainer/restart_button
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game):
		match game:
			GameManager.Game.NEW:
				visible = false
			GameManager.Game.OVER:
				visible = true
	)
	restart_button.pressed.connect(func(): GameManager.game = GameManager.Game.NEW)
#endregion
