extends Node
class_name Quest

signal quest_started(quest: Quest)
signal quest_completed

@export_group("Quest Settings")
@export var quest_name: String
@export var quest_description: String
@export var reached_goal_text: String

enum QuestStatus{
	available,
	started,
	reached_goal,
	finished,
}

@export var quest_status: QuestStatus = QuestStatus.available


@export_group("Reward Settings")
@export var reward_amount: int


func complete_quest():
	quest_status = QuestStatus.finished
	quest_completed.emit()
