extends Quest

var quest_box = preload("res://ui/quest/quest_box.tscn")
var quest_box_instance = null

var start_distance: float  # Simpan jarak awal saat quest dimulai

func initialize():
	quest_box_instance = quest_box.instantiate()

	get_tree().root.add_child(quest_box_instance)
	quest_box_instance.display_quest(self)
	
	quest_box_instance.quest_progress_label.text = "0/150"
	
	start_distance = GameManager.distance  # Ambil jarak saat quest dimulai
	GameManager.distance_changed.connect(check_distance)  # Hubungkan ke signal
	
	

func check_distance(new_distance: float):
	quest_box_instance.quest_progress_label.text = str(floori(new_distance - start_distance)) + "/150"

	if (new_distance - start_distance) >= 150:
		quest_box_instance.quest_progress_label.add_theme_color_override("font_color", Color(0, 1, 0))
		quest_box_instance.completed_audio_player.play_random()
		
		quest_box_instance.quest_progress_label.text = "150/150"
		quest_status = Quest.QuestStatus.reached_goal
		quest_completed.emit()
		
		get_parent().start_quest_interval_timer()
		
		if quest_box_instance:
			quest_box_instance.on_quest_completed()
			quest_box_instance = null

func cleanup():
	# Putuskan koneksi signal saat quest selesai
	if GameManager.distance_changed.is_connected(check_distance):
		GameManager.distance_changed.disconnect(check_distance)
		
		
	if quest_box_instance:
		quest_box_instance.quest_progress_label.text = "0/150"
		quest_box_instance.on_quest_completed()
		quest_box_instance = null
	
	
	quest_status = QuestStatus.available

	
