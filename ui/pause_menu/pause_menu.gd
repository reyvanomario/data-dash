class_name PauseMenu
extends Control
## The pause menu.

#region VARIABLES
## Button to unpause the game.
@onready var resume_button: Button = $VBoxContainer/VBoxContainer/resume_button
## Button to restart the a run.
@onready var restart_button: Button = $VBoxContainer/VBoxContainer/restart_button
## Button to go back home.
@onready var home_button: Button = $VBoxContainer/VBoxContainer/home_button
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.paused_changed.connect(func(paused: bool): visible = paused)
	resume_button.pressed.connect(func(): GameManager.paused = false)
	restart_button.pressed.connect(func():
		GameManager.game = GameManager.Game.NEW
		GameManager.game = GameManager.Game.PLAYING
		GameManager.paused = false
	)
	home_button.pressed.connect(func():
		GameManager.game = GameManager.Game.NEW
		GameManager.paused = false
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel') and GameManager.game == GameManager.Game.PLAYING:
		GameManager.paused = !GameManager.paused
		get_viewport().set_input_as_handled()
#endregion
