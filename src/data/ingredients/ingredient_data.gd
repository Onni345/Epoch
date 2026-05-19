extends Resource
class_name IngredientData

@export var id: String
@export var display_name: String

@export var tags: Array[String]

@export var base_moisture: float = 0.5
@export var base_texture: float = 0.5
@export var base_doneness: float = 0.0
@export var base_browned: float = 0.0

@export var heat_resistance: float = 0.5
@export var oil_absorption: float = 0.5
