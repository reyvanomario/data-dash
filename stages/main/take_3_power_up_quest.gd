extends Quest

var quest_box = preload("res://ui/quest/quest_box.tscn")
var quest_box_instance = null

var target = 3
var current = 0

func initialize():
	quest_box_instance = quest_box.instantiate()
	get_tree().root.add_child(quest_box_instance)
	quest_box_instance.display_quest(self)
	
	quest_box_instance.quest_progress_label.text = "0/3"

	
	var player = get_tree().get_first_node_in_group("player")
	player.power_up_collected.connect(on_power_up_collected)
	quest_status = QuestStatus.started

func cleanup():
	# Putuskan signal saat quest selesai/reset
	var player = get_tree().get_first_node_in_group("player")
	if player.power_up_collected.is_connected(on_power_up_collected):
		player.power_up_collected.disconnect(on_power_up_collected)
	quest_status = QuestStatus.available
	
	if quest_box_instance:
		quest_box_instance.on_quest_completed()
		quest_box_instance = null

func on_power_up_collected():
	current += 1
	quest_box_instance.quest_progress_label.text = str(current) + "/3"
	
	if current >= target:
		quest_box_instance.quest_progress_label.add_theme_color_override("font_color", Color(0, 1, 0))
		quest_box_instance.completed_audio_player.play_random()
		
		quest_status = QuestStatus.reached_goal
		quest_completed.emit()
		
		get_parent().start_quest_interval_timer()
