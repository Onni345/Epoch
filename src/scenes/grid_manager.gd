extends Node3D

signal grid_generation_completed

@export var tile_master_scene: PackedScene = preload("res://src/scenes/interactables/tile.tscn")
@export var grid_size: Vector2i = Vector2i(15, 15)
@export var cell_size: float = 1.0

var tile_registry: Dictionary = {}

func _ready() -> void:
	initialize_and_generate_grid()

func world_to_grid(world_pos: Vector3) -> Vector2i:
	var x = floor(world_pos.x / cell_size)
	var z = floor(world_pos.z / cell_size)
	return Vector2i(x, z)
	
func grid_to_world(coords: Vector2i) -> Vector3:
	var world_x = coords.x * cell_size + (cell_size / 2.0)
	var world_z = coords.y * cell_size + (cell_size / 2.0)
	return Vector3(world_x, 0, world_z)

func grid_to_world_PLAYER(coords: Vector2i) -> Vector3:
	var world_x = coords.x * cell_size + (cell_size / 2.0)
	var world_z = coords.y * cell_size + (cell_size / 2.0)
	return Vector3(world_x, 0.9, world_z)

func initialize_and_generate_grid() -> void:
	for x in grid_size.x:
		for z in grid_size.y:
			var coord = Vector2i(x, z)
			var new_tile = tile_master_scene.instantiate() as Tile
			
			if x >= 3 and x <= 5 and z >= 3 and z <= 5:
				new_tile.current_type = Tile.TileType.COUNTERTOP
			else:
				new_tile.current_type = Tile.TileType.FLOOR
			
			var world_x = x * cell_size + (cell_size / 2.0)
			var world_z = z * cell_size + (cell_size / 2.0)
			new_tile.transform.origin = Vector3(world_x, 0, world_z)
			
			tile_registry[coord] = new_tile
			add_child(new_tile)
			
	grid_generation_completed.emit()

func get_tile_at(coords: Vector2i) -> Tile:
	if tile_registry.has(coords):
		return tile_registry[coords] as Tile
	return null