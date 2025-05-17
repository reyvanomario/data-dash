# Bertahan40DetikQuest.gd
extends Quest

@onready var timer: Timer = $Timer

var quest_box = preload("res://ui/quest/quest_box.tscn")
var quest_box_instance = null


func _process(delta: float) -> void:
	if quest_status == QuestStatus.started:
		var time_elapsed = get_time_elapsed()
		quest_box_instance.quest_progress_label.text = format_seconds_to_string(time_elapsed)

	
func initialize():
	quest_box_instance = quest_box.instantiate()
	get_tree().root.add_child(quest_box_instance)
	quest_box_instance.display_quest(self)
	
	timer.wait_time = 40
	timer.timeout.connect(on_timer_timeout)
	timer.start()
	
	quest_box_instance.quest_progress_label.text = "0"
	
	var player = get_tree().get_first_node_in_group("player")
	player.took_damage.connect(reset_timer)
	
	
func get_time_elapsed():
	return timer.wait_time - timer.time_left
	

func format_seconds_to_string(seconds: float):
	var formatted_seconds = floori(seconds)
	
	return str(formatted_seconds)
	

func cleanup():
	quest_status = QuestStatus.available
	timer.stop()
	
	var player = get_tree().get_first_node_in_group("player")
	if player.took_damage.is_connected(reset_timer):
		player.took_damage.disconnect(reset_timer)
		
	if quest_box_instance:
		quest_box_instance.on_quest_completed()
		quest_box_instance = null

func reset_timer():
	timer.start()

func on_timer_timeout():
	quest_status = QuestStatus.reached_goal
	quest_box_instance.quest_progress_label.text = "40"
	quest_box_instance.quest_progress_label.add_theme_color_override("font_color", Color(0, 1, 0))
	quest_box_instance.completed_audio_player.play_random()

	quest_completed.emit()
	
	get_parent().start_quest_interval_timer()
