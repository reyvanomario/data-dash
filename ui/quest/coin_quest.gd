class_name CoinQuest
extends Quest

	
var quest_box = preload("res://ui/quest/quest_box.tscn")
var quest_box_instance = null

var coins_collected: int = 0


func initialize():
	# Pindahkan logika inisialisasi ke sini
	coins_collected = 0
	quest_box_instance = quest_box.instantiate()
	get_tree().root.add_child(quest_box_instance)
	quest_box_instance.display_quest(self)
	
	quest_box_instance.quest_progress_label.text = "0/50"
	
	var player = get_tree().get_first_node_in_group("player")
	player.coin_collected.connect(add_coin)
	self.connect("quest_completed", quest_box_instance.on_quest_completed)
		

func cleanup():
	var player = get_tree().get_first_node_in_group("player")
	if player.coin_collected.is_connected(add_coin):
		player.coin_collected.disconnect(add_coin)
	
	if quest_box_instance:
		quest_box_instance.on_quest_completed()
		quest_box_instance = null
	
	coins_collected = 0
	quest_status = QuestStatus.available

	
		
func add_coin():
	coins_collected += 1
	
	quest_box_instance.quest_progress_label.text = str(coins_collected) + "/50"
	
	#print("current coin: ", str(coins_collected))
	
	if coins_collected >= 50:
		quest_box_instance.quest_progress_label.add_theme_color_override("font_color", Color(0, 1, 0))
		quest_box_instance.completed_audio_player.play_random()
		
		quest_status = QuestStatus.reached_goal
		quest_completed.emit()
		
		get_parent().start_quest_interval_timer()
		 


		
