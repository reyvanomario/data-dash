extends Area2D

func _process(delta: float) -> void:
	position.x += -GameManager.speed * delta
	rotation += 1 * 1.5 * delta
