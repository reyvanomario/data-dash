class_name HUD
extends Control


## The label for the displaying the collected coins during the current run.
@onready var coins_label: Label = $HBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/coins
## The label for the displaying the current distance.
@onready var distance_label: Label = $HBoxContainer/VBoxContainer/MarginContainer/distance
## Button to pause the game.
@onready var pause_button: TextureButton = $HBoxContainer/VBoxContainer3/MarginContainer/pause_button

@onready var life_label: Label = $HBoxContainer/VBoxContainer/MarginContainer3/HeartsContainer/LifeLabel


func _ready() -> void:
	GameManager.game_changed.connect(func(game: int):
		match game:
			GameManager.Game.OVER, GameManager.Game.NEW:
				visible = false
			GameManager.Game.PLAYING:
				life_label.text = "x 1"
				visible = true
	)
	GameManager.distance_changed.connect(on_distance_changed)
	GameManager.coins_changed.connect(on_coins_changed)
	GameManager.multiplier_activated.connect(on_multiplier_activated)
	
	$MultiplierTimer.timeout.connect(on_multiplier_timer_timeout)
	
	pause_button.pressed.connect(on_pause_button_pressed)




func on_distance_changed(distance: float):
	distance_label.text = "%03dM" % floori(distance)
	
	
func on_coins_changed(coins: float):
	coins_label.text = "%03d" % floori(coins)
	
	
func on_pause_button_pressed():
	GameManager.paused = true
	
	
func on_multiplier_activated():
	$AnimationPlayer.play("multiplier")
	$MultiplierTimer.start()
	
	
func on_multiplier_timer_timeout():
	$AnimationPlayer.stop()
