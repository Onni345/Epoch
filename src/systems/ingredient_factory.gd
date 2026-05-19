extends Node
class_name IngredientFactory

static func create_instance(data: IngredientData) -> Dictionary:
	return {
		"data": data,

		"moisture": data.base_moisture,
		"texture": data.base_texture,
		"doneness": data.base_doneness,
		"browned": data.base_browned,

		"history": []
	}
