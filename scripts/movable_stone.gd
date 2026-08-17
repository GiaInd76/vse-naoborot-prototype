class_name MovableStone
extends StaticBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
var carried := false


func can_be_picked_up() -> bool:
	return not carried


func pick_up() -> void:
	carried = true
	collision.set_deferred("disabled", true)
	z_index = 5


func drop(target_position: Vector2) -> void:
	global_position = target_position
	carried = false
	collision.set_deferred("disabled", false)
	z_index = 0
