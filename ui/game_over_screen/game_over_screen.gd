extends Control

#region VARIABLES
@onready var restart_button: Button = $HBoxContainer/MarginContainer/VBoxContainer/restart_button
@onready var home_button: Button = $HBoxContainer/MarginContainer/VBoxContainer/home_button
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
	home_button.pressed.connect(func(): GameManager.game = GameManager.Game.NEW)
	restart_button.pressed.connect(func(): GameManager.game = GameManager.Game.NEW; GameManager.game = GameManager.Game.PLAYING)
#endregion
