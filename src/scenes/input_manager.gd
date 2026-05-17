extends Node3D

@onready var camera: Camera3D = $"../Camera3D"
@onready var grid_manager: Node3D = $"../GridManager"
@onready var chef: Node3D = $"../Chef"
@onready var nav_manager: Node3D = $"../NavManager"

var last_hovered_coord: Vector2i = Vector2i(-999, -999)

func _ready() -> void:
	pass 

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var requested_grid_coord = get_mouse_grid_position()
			var chef_pos_2D = grid_manager.world_to_grid(chef.position)
			
			if (requested_grid_coord != chef_pos_2D) and requested_grid_coord != Vector2i(-1, -1):
				var requested_tile: Tile = grid_manager.get_tile_at(requested_grid_coord)
				
				if requested_tile != null and not requested_tile.is_walkable:
					requested_grid_coord = bfs(requested_grid_coord, chef_pos_2D)
				
				if requested_grid_coord == Vector2i(-1, -1):
					return
				
				var grid_path = nav_manager.get_navigation_path(chef_pos_2D, requested_grid_coord)
				
				var world_waypoints: Array[Vector3] = []
				for coord in grid_path:
					var world_pos = grid_manager.grid_to_world_PLAYER(coord)
					world_waypoints.append(world_pos)
				
				if not world_waypoints.is_empty():
					chef.move(world_waypoints)

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
            
func get_mouse_grid_position() -> Vector2i:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	
	var floor_plane = Plane(Vector3.UP, 0.0)
	var intersection_point = floor_plane.intersects_ray(ray_origin, ray_normal)
	if intersection_point != null:
		return grid_manager.world_to_grid(intersection_point)
	
	return Vector2i(-1, -1)

func bfs(start_coord: Vector2i, chef_coord: Vector2i) -> Vector2i:
	var visited: Dictionary = {}
	var q: Array[Vector2i] = []
	
	q.push_back(start_coord)
	visited[start_coord] = true
	
	var directions: Array[Vector2i] = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]
	
	while not q.is_empty():
		var current_layer_size = q.size()
		var walkable_candidates: Array[Vector2i] = []
		
		for i in range(current_layer_size):
			var popped_tile_coords: Vector2i = q.pop_front()
			
			var tile = grid_manager.get_tile_at(popped_tile_coords)
			if tile != null and tile.is_walkable:
				walkable_candidates.append(popped_tile_coords)
				continue
			
			for dir in directions:
				var neighbor = popped_tile_coords + dir
				
				if neighbor.x < 0 or neighbor.x >= grid_manager.grid_size.x:
					continue
				if neighbor.y < 0 or neighbor.y >= grid_manager.grid_size.y:
					continue
				
				if not visited.has(neighbor):
					visited[neighbor] = true
					q.push_back(neighbor)
					
		if not walkable_candidates.is_empty():
			var closest_coord = walkable_candidates[0]
			var min_distance = chef_coord.distance_to(closest_coord)
			
			for candidate in walkable_candidates:
				var dist = chef_coord.distance_to(candidate)
				if dist < min_distance:
					min_distance = dist
					closest_coord = candidate
			return closest_coord
			
	return Vector2i(-1, -1)