extends Node
class_name TransformLibrary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func boil(ingredient: Dictionary, duration: float):
	ingredient.moisture += 0.2 * duration
	ingredient.doneness += 0.15 * duration

	ingredient.history.append("boiled")

static func fry(ingredient: Dictionary, duration: float):
	ingredient.browned += 0.3 * duration
	ingredient.doneness += 0.2 * duration

	ingredient.history.append("fried")
