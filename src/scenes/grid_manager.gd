extends Node3D

@export var tile_scene: PackedScene = preload("res://src/scenes/floor_tile.tscn")
@export var grid_size: Vector2i = Vector2i(9, 16)
@export var cell_size: float = 1.0

var tile_registry: Dictionary = {}

func _ready() -> void:
	generate_grid_visuals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func world_to_grid(world_pos: Vector3) -> Vector2i:
	
	var x = floor(world_pos.x / cell_size + grid_size.x) - grid_size.x
	var z = floor(world_pos.z / cell_size + grid_size.y) - grid_size.y
	
	return Vector2i(x, z)

func generate_grid_visuals() -> void:
	for x in grid_size.x:
		for z in grid_size.y:
			# Instantiate a visual tile
			var tile = tile_scene.instantiate() as Node3D
			add_child(tile)
			
			# map the x,z pos to this tile obj
			tile_registry[Vector2i(x, z)] = tile
			
			# Calculate the center position of the cell
			# Adding half the cell size centers the model inside the mathematical grid square
			var world_x = x * cell_size + (cell_size / 2.0)
			var world_z = z * cell_size + (cell_size / 2.0)
			
			tile.transform.origin = Vector3(world_x, 0, world_z)

func get_tile_at(coords: Vector2i) -> Node3D:
	if tile_registry.has(coords):
		return tile_registry[coords]
	return null
