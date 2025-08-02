extends Node2D
class_name PlacementGrid

@export var grid_size: Vector2 = Vector2(100, 100)
@export var grid_color: Color = Color(0.5, 0.5, 0.5, 0.3)
@export var valid_cell_color: Color = Color(0.2, 0.8, 0.2, 0.5)
@export var invalid_cell_color: Color = Color(0.8, 0.2, 0.2, 0.5)

var grid_cells: Array[Node2D] = []
var base_terrain: Node2D

func _ready() -> void:
	"""
	Initialize the placement grid.
	"""
	base_terrain = get_node_or_null("/root/Level01/BaseTerrain")
	_generate_grid()

func _generate_grid() -> void:
	"""
	Generate the visual grid overlay.
	"""
	if not base_terrain:
		return
	
	# Calculate grid bounds based on BaseTerrain
	var terrain_bounds = _get_terrain_bounds()
	var start_pos = terrain_bounds.position
	var end_pos = terrain_bounds.end
	
	# Create grid cells
	for x in range(start_pos.x, end_pos.x, grid_size.x):
		for y in range(start_pos.y, end_pos.y, grid_size.y):
			var cell = _create_grid_cell(Vector2(x, y))
			grid_cells.append(cell)
			add_child(cell)

func _create_grid_cell(pos: Vector2) -> Node2D:
	"""
	Create a single grid cell at the given position.
	"""
	var cell = Node2D.new()
	cell.position = pos
	
	var cell_rect = ColorRect.new()
	cell_rect.size = grid_size
	cell_rect.color = grid_color
	cell_rect.name = "CellRect"
	cell.add_child(cell_rect)
	
	return cell

func _get_terrain_bounds() -> Rect2:
	"""
	Get the bounds of the BaseTerrain for grid generation.
	"""
	if base_terrain:
		# Use the polygon bounds or a default area
		return Rect2(Vector2(0, 0), Vector2(50000, 20000))
	return Rect2(Vector2(0, 0), Vector2(1000, 1000))

func update_cell_validity(pos: Vector2, is_valid: bool) -> void:
	"""
	Update the visual state of the grid cell at the given position.
	"""
	var cell = _get_cell_at_position(pos)
	if cell:
		var cell_rect = cell.get_node_or_null("CellRect")
		if cell_rect:
			cell_rect.color = valid_cell_color if is_valid else invalid_cell_color

func _get_cell_at_position(pos: Vector2) -> Node2D:
	"""
	Get the grid cell at the given world position.
	"""
	for cell in grid_cells:
		var cell_rect = cell.get_node_or_null("CellRect")
		if cell_rect:
			var cell_bounds = Rect2(cell.global_position, cell_rect.size)
			if cell_bounds.has_point(pos):
				return cell
	return null

func highlight_cells_around(pos: Vector2, radius: float) -> void:
	"""
	Highlight grid cells around a position for visual feedback.
	"""
	for cell in grid_cells:
		var cell_rect = cell.get_node_or_null("CellRect")
		if cell_rect:
			var cell_center = cell.global_position + cell_rect.size / 2
			var distance = cell_center.distance_to(pos)
			
			if distance <= radius:
				cell_rect.modulate = Color(1.0, 1.0, 0.0, 0.7)  # Yellow highlight
			else:
				cell_rect.modulate = Color.WHITE

func clear_highlights() -> void:
	"""
	Clear all cell highlights.
	"""
	for cell in grid_cells:
		var cell_rect = cell.get_node_or_null("CellRect")
		if cell_rect:
			cell_rect.modulate = Color.WHITE

func is_position_valid(pos: Vector2) -> bool:
	"""
	Check if a position is valid for placement.
	"""
	# This could be enhanced with more sophisticated terrain analysis
	var cell = _get_cell_at_position(pos)
	return cell != null 