extends Node3D

@onready var astar_grid = AStarGrid2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_grid.region = Rect2i(0, 0, 9, 16)
	astar_grid.cell_size = Vector2i(1, 1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_navigation_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	# bounds check
	if astar_grid.is_in_bounds(start.x, start.y) and astar_grid.is_in_bounds(end.x, end.y):
		return astar_grid.get_id_path(start, end)
	return []
