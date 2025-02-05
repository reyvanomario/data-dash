class_name GameOverScreen
extends Control
## The game over UI.

#region VARIABLES
## Leaderboard entry scene to populate the leaderboard with.
@export var leaderboard_entry_scene: PackedScene

## The label for the displaying the current distance.
@onready var distance_label: Label = $HBoxContainer/VBoxContainer/distance
## The container for editing the name for the most recent score on the leaderboard.
@onready var highscore: VBoxContainer = $HBoxContainer/MarginContainer/highscore
## LineEdit node for entering the name for the leaderboard entry.
@onready var leaderboard_name: LineEdit = $HBoxContainer/MarginContainer/highscore/leaderboard_name
## Button used to save the leaderboard name and continue.
@onready var continue_button: Button = $HBoxContainer/MarginContainer/highscore/continue_button
## The container to display the leaderboard.
@onready var leaderboard: VBoxContainer = $HBoxContainer/MarginContainer/leaderboard
## The container for leaderboard entries.
@onready var leaderboard_entries_container: VBoxContainer = $HBoxContainer/MarginContainer/leaderboard/TabContainer/Leaderboard/MarginContainer/VBoxContainer
## The restart button, which will start a run instantly.
@onready var restart_button: Button = $HBoxContainer/MarginContainer/leaderboard/restart_button
## The home button, which will reset but wait on the player to start a run.
@onready var home_button: Button = $HBoxContainer/MarginContainer/leaderboard/home_button

## Is the latest run a new highscore?
var new_highscore: bool = false :
	set(h):
		new_highscore = h
		highscore.visible = new_highscore
		show_leaderboard = !new_highscore
## Should the leaderboard be visible?
var show_leaderboard: bool = false :
	set(l):
		show_leaderboard = l
		if show_leaderboard:
			generate_leaderboard()
		leaderboard.visible = show_leaderboard
		highscore.visible = !show_leaderboard
#endregion

#region FUNCTIONS
func _ready() -> void:
	GameManager.game_changed.connect(func(game):
		match game:
			GameManager.Game.NEW:
				visible = false
			GameManager.Game.OVER:
				distance_label.text = "%dM" % floori(GameManager.distance)
				new_highscore = SaveSystem.stats.leaderboard.is_highscore(GameManager.distance)
				visible = true
	)
	continue_button.pressed.connect(func():
		SaveSystem.stats.name = leaderboard_name.text if !leaderboard_name.text.is_empty() else SaveSystem.stats.name
		SaveSystem.add_to_leaderboard()
		show_leaderboard = true
	)
	home_button.pressed.connect(func(): GameManager.game = GameManager.Game.NEW)
	restart_button.pressed.connect(func(): GameManager.game = GameManager.Game.NEW; GameManager.game = GameManager.Game.PLAYING)

## Generating the leaderboard from the data in the save system.
func generate_leaderboard():
	for i in SaveSystem.stats.leaderboard.entries.size():
		var entry: LeaderboardEntry = SaveSystem.stats.leaderboard.entries[i]
		var entry_ui: LeaderboardEntryUI
		if leaderboard_entries_container.get_child_count() > i and leaderboard_entries_container.get_child(i) is LeaderboardEntryUI:
			entry_ui = leaderboard_entries_container.get_child(i)
		else:
			entry_ui = leaderboard_entry_scene.instantiate()
			leaderboard_entries_container.add_child(entry_ui)
		entry_ui.order = i + 1
		entry_ui.resource = entry
		entry_ui.setup_labels()
#endregion
