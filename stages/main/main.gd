extends Node2D

@onready var  coin_quest: Quest = $CoinQuest
@onready var quest_interval_timer = $QuestIntervalTimer

@onready var life_container = $CanvasLayer/HUD/HBoxContainer/VBoxContainer/MarginContainer3/HeartsContainer
@onready var player = $Player

@onready var quests: Array[Quest] = [
	$CoinQuest,
	$Take3PowerUpQuest,
	$SurvivalQuest,
	$DistanceQuest
]

var warning_vignette = preload("res://ui/vignette.tscn")


func _ready() -> void:
	quest_interval_timer.timeout.connect(on_quest_interval_timeout)
	
	GameManager.game_changed.connect(on_game_state_changed)
	
	#GameManager.game = GameManager.Game.PLAYING
	#print(GameManager.game)
	
	
		
	
func start_quest_interval_timer():
	quest_interval_timer.start()
	
	
func on_quest_interval_timeout():
	var available = quests.filter(func(q): return q.quest_status == Quest.QuestStatus.available)

	if available.size() > 0:
		var selected = available.pick_random()
		QuestManager.start_quest(selected)
	
	
func on_game_state_changed(game_state: int) -> void:
	match game_state:
		GameManager.Game.PLAYING:
			var vignette_instance = warning_vignette.instantiate()
			add_child(vignette_instance)
			
			$RandomStreamPlayerComponent.play_random()
			
			await $RandomStreamPlayerComponent.finished
			
			vignette_instance.queue_free()
	
			# Mulai timer quest setelah game mulai
			quest_interval_timer.start()
		GameManager.Game.NEW:
			# Hentikan timer bila game belum dijalankan atau sudah berakhir
			quest_interval_timer.stop()
			
			
			QuestManager.reset_quests()
			

			quest_interval_timer.start()
		
		GameManager.Game.OVER:
			quest_interval_timer.stop()
			
			QuestManager.reset_quests()
			


			
