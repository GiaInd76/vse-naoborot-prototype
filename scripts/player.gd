class_name Player
extends CharacterBody2D

@export_range(100.0, 1000.0, 10.0) var speed: float = 470.0
@export_range(0.2, 1.5, 0.05) var jump_duration: float = 0.55
@export_range(10.0, 150.0, 5.0) var jump_height: float = 70.0

@onready var visual: Node2D = $Visual

const VISUAL_GROUND_OFFSET := -22.0

var facing := Vector2.DOWN
var jump_time := 0.0
var carried_stone: MovableStone


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and jump_time <= 0.0:
		jump_time = jump_duration
		# Слой 1 — границы, слой 2 — объекты, через которые можно перепрыгнуть.
		collision_mask = 1
	if event.is_action_pressed("interact"):
		_toggle_stone()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		facing = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	z_index = clampi(int(global_position.y), 0, 4095)
	_update_jump(delta)
	if is_instance_valid(carried_stone):
		carried_stone.global_position = global_position + facing * 72.0 + Vector2(0.0, visual.position.y)


func _update_jump(delta: float) -> void:
	if jump_time <= 0.0:
		visual.position.y = VISUAL_GROUND_OFFSET
		return
	jump_time = maxf(jump_time - delta, 0.0)
	var progress := 1.0 - jump_time / jump_duration
	visual.position.y = VISUAL_GROUND_OFFSET - sin(progress * PI) * jump_height
	if jump_time <= 0.0:
		visual.position.y = VISUAL_GROUND_OFFSET
		collision_mask = 3


func _toggle_stone() -> void:
	if is_instance_valid(carried_stone):
		carried_stone.drop(global_position + facing * 82.0)
		carried_stone = null
		return

	var nearest: MovableStone
	var nearest_distance := 115.0
	for stone: MovableStone in get_tree().get_nodes_in_group("movable_stones"):
		var distance := global_position.distance_to(stone.global_position)
		if distance < nearest_distance and stone.can_be_picked_up():
			nearest = stone
			nearest_distance = distance
	if nearest:
		carried_stone = nearest
		carried_stone.pick_up()
