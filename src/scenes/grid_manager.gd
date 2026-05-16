extends Node3D

@export var tile_scene: PackedScene = preload("res://src/scenes/floor_tile.tscn")
@export var grid_size: Vector2i = Vector2i(10, 10)
@export var cell_size: float = 1.0

func _ready() -> void:
	generate_grid_visuals()


func generate_grid_visuals() -> void:
	for x in grid_size.x:
		for z in grid_size.y:
			# Instantiate a visual tile
			var tile = tile_scene.instantiate() as Node3D
			add_child(tile)
			
			# Calculate the center position of the cell
			# Adding half the cell size centers the model inside the mathematical grid square
			var world_x = (x-5) * cell_size + (cell_size / 2.0)
			var world_z = (z-5) * cell_size + (cell_size / 2.0)
			
			tile.transform.origin = Vector3(world_x, 0, world_z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
