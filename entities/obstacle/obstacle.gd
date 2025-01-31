class_name Obstacle
extends Area2D

signal screen_entered
signal screen_exited

func _ready():
	var visible_on_screen_notifier_2D:VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
	visible_on_screen_notifier_2D.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2D.screen_exited.connect(func(): self.screen_exited.emit())

func _process(delta: float) -> void:
	position.x += -GameManager.speed * delta
	rotation += 1 * 1.5 * delta
