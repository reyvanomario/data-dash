class_name Collector2D
extends Area2D

#region VARIABLES
@export var collectable_identifiers: Array[String] = []

## The collision shape for the destructor.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is Collectable2D:
			if area.identifier in collectable_identifiers:
				area.collect()
	)
#endregion
