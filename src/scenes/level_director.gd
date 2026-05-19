extends Node3D
class_name LevelDirector

@export var camera_fov: float = 42.0
@export var camera_angle_pitch: float = -62.0 
@export var camera_distance_multiplier: float = 1.15

# preload chef scene
@export var chef_scene: PackedScene = preload("res://src/entities/chef/chef.tscn")

@onready var grid_manager = $"../GridManager"
@onready var input_manager = $"../InputManager"

var camera: Camera3D = null
var sun_light: DirectionalLight3D = null
var world_environment: WorldEnvironment = null
var chef_instance: Node3D = null

func _ready() -> void:
	if grid_manager.has_signal("grid_generation_completed"):
		grid_manager.grid_generation_completed.connect(_on_grid_ready)

func _on_grid_ready() -> void:
	setup_cinematic_environment()
	spawn_chef_in_kitchen() # Spawn character first
	setup_camera()

# set up environment in script
func setup_cinematic_environment() -> void:
	world_environment = WorldEnvironment.new()
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.12, 0.14, 0.18, 1.0) 
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.4, 0.45, 0.5)
	env.ambient_light_energy = 0.85
	world_environment.environment = env
	add_child(world_environment)
	
	sun_light = DirectionalLight3D.new()
	sun_light.light_color = Color(1.0, 0.95, 0.88) 
	sun_light.light_energy = 1.2
	sun_light.shadow_enabled = true
	sun_light.shadow_bias = 0.04
	sun_light.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	sun_light.transform.basis = Basis(Vector3(1, 0, 0), deg_to_rad(-55)) * Basis(Vector3(0, 1, 0), deg_to_rad(35))
	add_child(sun_light)

func spawn_chef_in_kitchen() -> void:
	if chef_scene == null:
		return
		
	chef_instance = chef_scene.instantiate() as Node3D
	
	# place iniital chef
	chef_instance.transform.origin = grid_manager.grid_to_world_PLAYER(Vector2i(2, 2))
	
	# delay tree insertion until safe for no reace condition
	get_parent().call_deferred("add_child", chef_instance)
	
	# inject live reference directly into InputManager
	if input_manager != null:
		input_manager.chef = chef_instance

func setup_camera() -> void:
	camera = Camera3D.new()
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	camera.fov = camera_fov
	
	var max_x = grid_manager.grid_size.x * grid_manager.cell_size
	var max_z = grid_manager.grid_size.y * grid_manager.cell_size
	var grid_center = Vector3(max_x / 2.0, 0.0, max_z / 2.0)
	var required_distance = max(max_x, max_z) * camera_distance_multiplier
	
	var camera_pos = Vector3(
		grid_center.x,
		required_distance * 1.1, 
		grid_center.z + (required_distance * 0.65)
	)
	
	camera.transform.origin = camera_pos
	camera.rotation_degrees = Vector3(camera_angle_pitch, 0.0, 0.0)

	add_child(camera)
	
	camera.look_at(grid_center, Vector3.UP)
	
	if input_manager != null:
		input_manager.camera = camera
