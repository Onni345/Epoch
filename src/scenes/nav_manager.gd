extends Node3D

@onready var astar_grid = AStarGrid2D.new()
@onready var grid_manager = $"../GridManager"

func _ready() -> void:
	var max_size = grid_manager.grid_size
	astar_grid.region = Rect2i(0, 0, max_size.x, max_size.y)
	astar_grid.cell_size = Vector2i(1, 1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	if grid_manager.tile_registry.is_empty():
		grid_manager.grid_generation_completed.connect(synchronize_navigation_obstacles)
	else:
		synchronize_navigation_obstacles()

func synchronize_navigation_obstacles() -> void:
	for coord in grid_manager.tile_registry:
		var tile_node = grid_manager.tile_registry[coord]
		if tile_node != null:
			astar_grid.set_point_solid(coord, not tile_node.is_walkable)
			
	astar_grid.update()

func get_navigation_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if astar_grid.is_in_bounds(start.x, start.y) and astar_grid.is_in_bounds(end.x, end.y):
		if astar_grid.is_point_solid(end):
			return []
		return astar_grid.get_id_path(start, end)
	return []
