extends Node2D

const WORLD_SIZE := Vector2(6000.0, 4000.0)
const GRID_STEP := 400.0


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, WORLD_SIZE), Color("58a85b"))

	var grid_color := Color(0.22, 0.49, 0.25, 0.35)
	var x := GRID_STEP
	while x < WORLD_SIZE.x:
		draw_line(Vector2(x, 0.0), Vector2(x, WORLD_SIZE.y), grid_color, 3.0)
		x += GRID_STEP

	var y := GRID_STEP
	while y < WORLD_SIZE.y:
		draw_line(Vector2(0.0, y), Vector2(WORLD_SIZE.x, y), grid_color, 3.0)
		y += GRID_STEP

	draw_rect(Rect2(Vector2.ZERO, WORLD_SIZE), Color("276b35"), false, 12.0)


func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
