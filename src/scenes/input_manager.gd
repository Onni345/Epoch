extends Node3D

@onready var camera: Camera3D = $"../Camera3D"
@onready var grid_manager: Node3D = $"../GridManager"

var last_hovered_coord: Vector2i = Vector2i(-999, -999)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_grid_coord = get_mouse_grid_position()
	if (current_grid_coord != last_hovered_coord):
		var old_tile: Node3D = grid_manager.get_tile_at(last_hovered_coord)
		var new_tile: Node3D = grid_manager.get_tile_at(current_grid_coord)
		if old_tile != null:
			old_tile.set_hover_state(false)

		if new_tile != null:
			new_tile.set_hover_state(true)
		last_hovered_coord = current_grid_coord
		
	# print("Hovering over: ", current_grid_coord)
	
	pass

func get_mouse_grid_position() -> Vector2i:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	
	var floor_plane = Plane(Vector3.UP, 0.0)
	var intersection_point = floor_plane.intersects_ray(ray_origin, ray_normal)
	if intersection_point != null:
		return grid_manager.world_to_grid(intersection_point)
	
	return Vector2i(-1, -1)
