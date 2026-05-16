extends Node3D

@onready var camera: Camera3D = $"../Camera3D"
@onready var grid_manager: Node3D = $"../GridManager"
@onready var chef: Node3D = $"../Chef"
@onready var nav_manager: Node3D = $"../NavManager"

var last_hovered_coord: Vector2i = Vector2i(-999, -999)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var requested_grid_coord = get_mouse_grid_position()
			var chef_pos_2D = grid_manager.world_to_grid(chef.position)
			
			if (requested_grid_coord != chef_pos_2D) and requested_grid_coord != Vector2i(-1, -1):
				var grid_path = nav_manager.get_navigation_path(chef_pos_2D, requested_grid_coord)
				
				var world_waypoints: Array[Vector3] = []
				for coord in grid_path:
					var world_pos = grid_manager.grid_to_world_PLAYER(coord)
					world_waypoints.append(world_pos)
				
				if not world_waypoints.is_empty():
					chef.move(world_waypoints)

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
