extends Node3D
class_name Tile

enum TileType { FLOOR, COUNTERTOP, STOVETOP }

@export var current_type: TileType = TileType.FLOOR
@export var is_walkable: bool = true

var visual_instance: Node3D = null
var mesh_node: MeshInstance3D = null
var original_mesh_y: float = 0.0

const FLOOR_MESH = preload("res://src/scenes/interactables/floor_tile.tscn")
const COUNTER_MESH = preload("res://src/scenes/interactables/countertop.tscn")
const STOVE_MESH = preload("res://src/scenes/interactables/stovetop.tscn")

func _ready() -> void:
	if current_type != TileType.FLOOR:
		is_walkable = false
	setup_visuals()

func setup_visuals() -> void:
	if current_type == TileType.COUNTERTOP:
		visual_instance = COUNTER_MESH.instantiate()
	elif current_type == TileType.STOVETOP:
		visual_instance = STOVE_MESH.instantiate()
	elif current_type == TileType.FLOOR:
		visual_instance = FLOOR_MESH.instantiate()
		
	add_child(visual_instance)
	
	if visual_instance.has_node("MeshInstance3D"):
		mesh_node = visual_instance.get_node("MeshInstance3D") as MeshInstance3D
		# Cache whatever baseline Y value the scene file natively uses!
		original_mesh_y = mesh_node.position.y

func set_hover_state(is_hovered: bool) -> void:
	var target_node = mesh_node if mesh_node != null else visual_instance
	if target_node == null:
		return
	
	if is_hovered:
		# Dynamic Lift: Add 0.1 to whatever its unique starting point was
		target_node.position.y = original_mesh_y + 0.1
	else:
		# Perfect Return: Drop back down exactly to its native baseline
		target_node.position.y = original_mesh_y