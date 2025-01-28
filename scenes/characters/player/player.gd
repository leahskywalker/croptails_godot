class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool


@export var speed: int = 50
@export var state_machine: NodeStateMachine

var is_performing_action: bool = false
var direction = Vector2.ZERO

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _process(delta):
	if is_performing_action:
		return
	
	if Input.is_action_just_pressed("hit"):
		is_performing_action = true
		match current_tool:
			DataTypes.Tools.AxeWood:
				state_machine.transition_to("Chopping")
			DataTypes.Tools.TillGround:
				state_machine.transition_to("Tilling")
			DataTypes.Tools.WaterCrops:
				state_machine.transition_to("Watering")
		
	
	if Input.is_action_pressed("walk_left"):
		direction.x -= 1
	if Input.is_action_pressed("walk_right"):
		direction.x += 1
	if Input.is_action_pressed("walk_up"):
		direction.y -= 1
	if Input.is_action_pressed("walk_down"):
		direction.y += 1
	return
		
	if direction != Vector2.ZERO:
		velocity = direction.normalized()
		state_machine.transition_to("Walking")
	else:
		velocity = Vector2.ZERO
		state_machine.transition_to("Idle")
		
		move_and_slide()
