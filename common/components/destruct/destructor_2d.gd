class_name Destructor2D
extends Area2D
## A simple component to make anything a destructor.

#region VARIABLES
## The amount of destruction.
@export_range(1, 10) var destruct_amount: int = 1

## The collision shape for the destructor.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is Destructable2D:
			area.destruct(destruct_amount)
	)
#endregion
