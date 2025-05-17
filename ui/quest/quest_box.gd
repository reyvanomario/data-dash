extends CanvasLayer

#@onready var quest_title_label: Label = $%QuestTitleLabel
@onready var quest_description_label: Label = $%QuestDescriptionLabel
@onready var quest_progress_label: Label = $%QuestProgressLabel

@onready var animation_player = $AnimationPlayer
@onready var completed_audio_player = $RandomStreamPlayerComponent


func _ready() -> void:
	animation_player.play("transition_in")
	
	GameManager.game_changed.connect(on_game_changed)
	
	
func display_quest(quest: Quest):
	visible = true

	quest_description_label.text = str(quest.quest_description)

func on_quest_completed():		
	animation_player.play("transition_out")
	await animation_player.animation_finished
	
	queue_free()
	
	
func on_game_changed(game: int):
	if game == GameManager.Game.NEW:
		on_quest_completed()
	
