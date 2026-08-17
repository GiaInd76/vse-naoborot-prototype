extends Node2D

const TREES := preload("res://Free asset pack, thank u so much!/4. Trees.png")
const PLANTS := preload("res://Free asset pack, thank u so much!/5. Flowers and plants.png")
const ROCKS := preload("res://Free asset pack, thank u so much!/3. Rocks and cliffs.png")

const TREE_REGIONS: Array[Rect2] = [
	Rect2(63, 105, 300, 340), Rect2(405, 105, 300, 340),
	Rect2(755, 105, 310, 340), Rect2(45, 450, 285, 315),
	Rect2(335, 450, 285, 315), Rect2(620, 450, 285, 315),
]
const PLANT_REGIONS: Array[Rect2] = [
	Rect2(38, 145, 125, 160), Rect2(220, 145, 125, 160),
	Rect2(405, 145, 125, 160), Rect2(590, 145, 125, 160),
	Rect2(35, 520, 150, 180), Rect2(270, 520, 150, 180),
	Rect2(470, 520, 155, 180),
]
const ROCK_REGIONS: Array[Rect2] = [
	Rect2(45, 125, 125, 115), Rect2(210, 145, 100, 90),
	Rect2(365, 155, 145, 85), Rect2(540, 135, 155, 110),
	Rect2(710, 120, 185, 130),
]

var stream_points := PackedVector2Array([
	Vector2(2050, 0), Vector2(2020, 400), Vector2(1870, 780),
	Vector2(1930, 1180), Vector2(1780, 1580), Vector2(1820, 1990),
	Vector2(1660, 2400), Vector2(1700, 2800), Vector2(1530, 3220),
	Vector2(1580, 3620), Vector2(1490, 4000),
])

var tree_positions := PackedVector2Array([
	Vector2(260, 330), Vector2(520, 300), Vector2(790, 390),
	Vector2(300, 720), Vector2(610, 790), Vector2(1000, 650),
	Vector2(2400, 300), Vector2(2690, 470), Vector2(2350, 720),
	Vector2(270, 1350), Vector2(560, 1510), Vector2(900, 1370),
	Vector2(2470, 1260), Vector2(2730, 1510),
	Vector2(280, 2450), Vector2(570, 2640), Vector2(930, 2510),
	Vector2(2470, 2520), Vector2(2740, 2710),
	Vector2(250, 3450), Vector2(570, 3680), Vector2(920, 3500),
	Vector2(2240, 3540), Vector2(2650, 3670),
])

var plant_positions := PackedVector2Array([
	Vector2(1240, 360), Vector2(1580, 470), Vector2(2250, 520),
	Vector2(1200, 860), Vector2(1540, 930), Vector2(2180, 940),
	Vector2(1320, 1290), Vector2(2130, 1380), Vector2(1180, 1720),
	Vector2(1480, 1800), Vector2(2200, 1730), Vector2(2580, 1900),
	Vector2(1130, 2260), Vector2(1370, 2430), Vector2(2080, 2320),
	Vector2(2300, 2760), Vector2(1180, 2890), Vector2(1980, 3020),
	Vector2(1120, 3300), Vector2(1900, 3500), Vector2(2440, 3300),
])

var rock_positions := PackedVector2Array([
	Vector2(1770, 300), Vector2(2170, 620), Vector2(1690, 1030),
	Vector2(2040, 1280), Vector2(1570, 1510), Vector2(1990, 1770),
	Vector2(1510, 2180), Vector2(1900, 2500), Vector2(1450, 2730),
	Vector2(1810, 3100), Vector2(1370, 3430), Vector2(1700, 3750),
])

var flow_offset := 0.0


func _ready() -> void:
	_spawn_stream_collisions()
	_spawn_trees()
	_spawn_decor(PLANTS, PLANT_REGIONS, plant_positions, 0.52)
	_spawn_decor(ROCKS, ROCK_REGIONS, rock_positions, 0.72)


func _process(delta: float) -> void:
	flow_offset = fmod(flow_offset + delta * 85.0, 150.0)
	queue_redraw()


func _draw() -> void:
	# Широкая тёмная линия создаёт естественный берег под водой.
	draw_polyline(stream_points, Color("536f35"), 286.0, true)
	draw_polyline(stream_points, Color("9b733e"), 254.0, true)
	draw_polyline(stream_points, Color("238fc4"), 218.0, true)
	draw_polyline(stream_points, Color("35b4dc"), 178.0, true)

	# Короткие блики движутся по каждому участку и показывают течение вниз.
	for index: int in range(stream_points.size() - 1):
		var start: Vector2 = stream_points[index]
		var finish: Vector2 = stream_points[index + 1]
		var segment: Vector2 = finish - start
		var segment_length: float = segment.length()
		var direction: Vector2 = segment.normalized()
		var distance: float = flow_offset
		while distance < segment_length:
			var point: Vector2 = start + direction * distance
			draw_line(point, point + direction * 34.0, Color(0.72, 0.94, 1.0, 0.7), 5.0, true)
			distance += 150.0


func _spawn_trees() -> void:
	for index: int in range(tree_positions.size()):
		var body := StaticBody2D.new()
		body.name = "Tree%02d" % (index + 1)
		body.position = tree_positions[index]
		body.z_index = clampi(int(body.position.y), 0, 4095)
		body.collision_layer = 2
		body.collision_mask = 1

		var sprite: Sprite2D = _make_sprite(TREES, TREE_REGIONS[index % TREE_REGIONS.size()])
		var scale_factor: float = 0.78 + float(index % 3) * 0.06
		sprite.scale = Vector2.ONE * scale_factor
		sprite.position.y = -105.0 * scale_factor
		body.add_child(sprite)

		var collision := CollisionShape2D.new()
		var shape := CircleShape2D.new()
		shape.radius = 34.0 * scale_factor
		collision.shape = shape
		body.add_child(collision)
		add_child(body)


func _spawn_decor(texture: Texture2D, regions: Array[Rect2], positions: PackedVector2Array, scale_factor: float) -> void:
	for index: int in range(positions.size()):
		var sprite: Sprite2D = _make_sprite(texture, regions[index % regions.size()])
		sprite.name = "Decor%02d" % (get_child_count() + 1)
		sprite.position = positions[index]
		sprite.z_index = clampi(int(sprite.position.y), 0, 4095)
		sprite.scale = Vector2.ONE * (scale_factor + float(index % 3) * 0.05)
		add_child(sprite)


func _spawn_stream_collisions() -> void:
	for index: int in range(stream_points.size() - 1):
		var segment: Vector2 = stream_points[index + 1] - stream_points[index]
		var body := StaticBody2D.new()
		body.name = "StreamSegment%02d" % (index + 1)
		body.position = (stream_points[index] + stream_points[index + 1]) * 0.5
		body.rotation = segment.angle()
		body.collision_layer = 2
		body.collision_mask = 1

		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(segment.length(), 185.0)
		collision.shape = shape
		body.add_child(collision)
		add_child(body)


func _make_sprite(texture: Texture2D, region: Rect2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = region
	return sprite
