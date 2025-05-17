class_name QuestManager
extends Node

static var instance: QuestManager
signal active_quest_changed(quest: Quest)

static var active_quest: Quest = null

func _init():
	instance = self
	
	
static func has_active_quest() -> bool:
	return active_quest != null

static func start_quest(quest: Quest):
	if active_quest != null:
		return
	
	active_quest = quest
	active_quest.quest_status = Quest.QuestStatus.started
	active_quest.quest_started.emit(quest)
	
	# Panggil initialize() jika ada
	if quest.has_method("initialize"):
		quest.initialize()
	
	quest.connect("quest_completed", func():
		if quest.has_method("cleanup"):
			quest.cleanup() 
		GameManager.quest_bonus += quest.reward_amount
		active_quest = null
	)

static func reset_quests():
	if active_quest != null:
		if active_quest.has_method("cleanup"):

			active_quest.cleanup()
		active_quest = null
