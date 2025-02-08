class_name HUD
extends Control
## The game HUD (heads-up display).
##
## This contains stats and pause button.

#region VARIABLES
## The label for the displaying the current distance.
@onready var distance_label: Label = $HBoxContainer/VBoxContainer/MarginContainer/distance
@onready var coins_label: Label = $HBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/coins
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game: int):
		match game:
			GameManager.Game.OVER, GameManager.Game.NEW:
				visible = false
			GameManager.Game.PLAYING:
				visible = true
	)
	GameManager.distance_changed.connect(func(distance: float): distance_label.text = "%03dM" % floori(distance))
	GameManager.coins_changed.connect(func(coins: float): coins_label.text = "%03d" % floori(coins))
#endregion
