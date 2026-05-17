extends Node3D
class_name Tile

enum TileType { FLOOR, COUNTERTOP }

@export var current_type: TileType = TileType.FLOOR
@export var is_walkable: bool = true
var visual_instance: Node3D = null

const FLOOR_MESH = preload("res://src/scenes/interactables/floor_tile.tscn")
const COUNTER_MESH = preload("res://src/scenes/interactables/countertop.tscn")

func _ready() -> void:
	if current_type == TileType.COUNTERTOP:
		is_walkable = false
	setup_visuals()

func setup_visuals() -> void:
	if current_type == TileType.COUNTERTOP:
		visual_instance = COUNTER_MESH.instantiate()
	elif current_type == TileType.FLOOR:
		visual_instance = FLOOR_MESH.instantiate()
		
	add_child(visual_instance)

func set_hover_state(is_hovered: bool) -> void:
	if visual_instance == null:
		return
	
	if is_hovered:
		visual_instance.position.y = 0.1
	else:
		visual_instance.position.y = 0.0