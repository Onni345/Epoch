@tool
extends Node3D
class_name Tile

enum TileType { FLOOR, COUNTERTOP, STOVETOP }

@export var current_type: TileType = TileType.FLOOR:
	set(value):
		current_type = value
		if current_type != TileType.FLOOR:
			is_walkable = false
		setup_visuals()

@export var is_walkable: bool = true

var visual_instance: Node3D = null
var mesh_node: MeshInstance3D = null
var original_mesh_y: float = 0.0

const FLOOR_MESH = preload("res://src/scenes/interactables/floor_tile.tscn")
const COUNTER_MESH = preload("res://src/scenes/interactables/countertop.tscn")
const STOVE_MESH = preload("res://src/scenes/interactables/stovetop.tscn")

func _ready() -> void:
	setup_visuals()

func setup_visuals() -> void:
	if visual_instance != null:
		visual_instance.queue_free()
		
	var mat = StandardMaterial3D.new()
	
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	mat.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
	mat.specular_mode = BaseMaterial3D.SPECULAR_TOON
	mat.roughness = 0.6
		
	if current_type == TileType.COUNTERTOP:
		visual_instance = COUNTER_MESH.instantiate()
		mat.albedo_color = Color(0.65, 0.65, 0.65)
	elif current_type == TileType.STOVETOP:
		visual_instance = STOVE_MESH.instantiate()
		mat.albedo_color = Color(0.85, 0.25, 0.65)
	elif current_type == TileType.FLOOR:
		visual_instance = FLOOR_MESH.instantiate()
		mat.albedo_color = Color(0.45, 0.42, 0.4)
	
	if visual_instance == null: 
		return
	add_child(visual_instance)
	
	if visual_instance.has_node("MeshInstance3D"):
		mesh_node = visual_instance.get_node("MeshInstance3D") as MeshInstance3D
		mesh_node.material_override = mat
		
		# Cache whatever baseline Y value the mesh natively uses( for translation animations)
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
