class_name WateringCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
@export var watered_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var watered_terrain: int = 4

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.WaterCrops:
			get_cell_under_mouse()
			water_soil()

func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func water_soil() -> void:
	if distance < 20.0:
		if tilled_soil_tilemap_layer.get_cell_source_id(cell_position) != 1:
			watered_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, watered_terrain, true)
