class_name Zapper
extends Obstacle

var init_rotation: float = 0
var is_rotating: bool = false

func _ready() -> void:
	self.possible_spawn_points = [
		Vector2(2000, 240),
		Vector2(2000, 440),
		Vector2(2000, 640),
		Vector2(2000, 840),
	]
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	
	if is_rotating:
		rotation -= 1 * 1.5 * delta

func spawn() -> void:
	super.spawn()
	is_rotating = randi_range(0, 4) == 0

func disable() -> void:
	super.disable()
	rotation = init_rotation
