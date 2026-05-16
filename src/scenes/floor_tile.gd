extends Node3D
@onready var tile_mesh: MeshInstance3D = $"MeshInstance3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_hover_state(is_hovered: bool) -> void:
	if is_hovered:
		tile_mesh.position.y = 0.1
	else:
		tile_mesh.position.y = 0.0
