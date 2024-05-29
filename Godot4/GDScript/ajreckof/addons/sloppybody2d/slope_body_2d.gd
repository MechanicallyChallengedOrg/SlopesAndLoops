## The Player class represents a character in a 2D platformer game.
##
@tool
extends CharacterBody2D
class_name SlopeBody2D
## This a Physical body that handles mvement along slopes and loops 
##
## This is a Physical body that can be controled left and right and follow the floor whatever it's direction. it handles both movement and gravity. 
## To enable obstacles that intersect (such as loops), the concept of layers was introduced. Both bodies and obstacles can only exist on one layer at a time and can interact only with elements on the same layer. Additionally, layers change the z-index to keep intersections visually consistent.


## The size of the player character.
@export var PLAYER_SIZE = 16

## The maximum slope angle the player can walk on. If the floor has a higher angle then that the player will lose speed until he goes downward.
@export_range(0, 180, 0.1, "radians_as_degrees") var MAX_CLIMBING_SLOPE = PI/4

## The gravity affecting the player proportionate to [member PLAYER_SIZE] .
@export var GRAVITY = 100

## The maximum speed the player can reach proportionate to [member PLAYER_SIZE].
@export var MAX_SPEED = 100 




## The snap distance used for floor detection.
@export_range(0, 1, 0.01) var snap_distance : float = 0.5 :
	set(value):
		snap_distance = value
		if _down_direction_raycast:
			_down_direction_raycast.target_position = Vector2.DOWN * (value + 1) * PLAYER_SIZE
	get:
		return snap_distance 


@onready var _MAX_SPEED_FRICTION_MODIFIER = sin(MAX_CLIMBING_SLOPE) * GRAVITY / MAX_SPEED
@onready var _FRICTION = _MAX_SPEED_FRICTION_MODIFIER / (1 + _MAX_SPEED_FRICTION_MODIFIER)
@onready var _NON_FRICTION = (1 - _FRICTION)
@onready var _FULL_MAX_SPEED = MAX_SPEED * PLAYER_SIZE
@onready var _FULL_GRAVITY = GRAVITY * PLAYER_SIZE

## velocity towards the forward direction. See [method get_forward] for more information.
var _velocity_forward = 0
## velocity towards [member CharacterBody2D.up_direction]
var _velocity_up = 0
var _is_on_floor = false


@onready var _down_direction_raycast : RayCast2D 

## The collision layer of the player.
var layer : int = 1:
	set(value):
		if value == layer:
			return
		if value :
			layer = value & ~ layer 
			z_index = -layer
			collision_layer = layer
			collision_mask = layer
			_down_direction_raycast.collision_mask = layer
			_down_direction_raycast.force_raycast_update()

## Gets the forward direction of the player. This corresponds to the direction the body will go when pressing [kbd]slope_body_2d_right[/kbd] and is calculated from [member CharacterBody2D.up_direction] by rotating it by 90°.
func get_forward():
	return up_direction.rotated(PI/2)

func _ready() -> void:
	_down_direction_raycast = RayCast2D.new()
	_down_direction_raycast.target_position = Vector2.DOWN * (snap_distance + 1) * PLAYER_SIZE
	add_child(_down_direction_raycast)
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(delta):
	if Engine.is_editor_hint() :
		return
	
	_snap_to_floor()
	if _is_on_floor:
		if _velocity_up > -5 or Vector2.DOWN.dot(up_direction) > 0 :
			_velocity_up += _FULL_GRAVITY * delta * Vector2.DOWN.dot(up_direction)

		
		## Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("ui_left", "ui_right")

		if direction:
			_velocity_forward += direction * _FULL_MAX_SPEED * _MAX_SPEED_FRICTION_MODIFIER * delta
		if not floor_stop_on_slope or abs(up_direction.angle_to(Vector2.UP)) > MAX_CLIMBING_SLOPE / 4:
			_velocity_forward += _FULL_GRAVITY * delta * Vector2.DOWN.dot(get_forward())
		_velocity_forward *= _NON_FRICTION / (_NON_FRICTION + _FRICTION * delta)
	else : 
		_velocity_up += _FULL_GRAVITY * delta * Vector2.DOWN.dot(up_direction)
		_velocity_forward += _FULL_GRAVITY * delta * Vector2.DOWN.dot(get_forward())

	_validate_velocity()
	velocity = _velocity_forward * get_forward() + _velocity_up * up_direction
	move_and_slide()


## This is a virtual function that you can redefine to enables custom movement. This function is called after basic calculation of the velocity has been done and just before [method CharacterBody2D.move_and_slide] is called 
func _validate_velocity():
	pass

var _snap_collision : KinematicCollision2D
func _snap_to_floor():
	if is_on_wall():
		up_direction = get_wall_normal()
		rotation = - up_direction.angle_to(Vector2.UP)
		if not _is_on_floor :
			_velocity_forward = velocity.dot(get_forward())
			_velocity_up = 0
		_is_on_floor = true
	elif _is_on_floor and _down_direction_raycast.is_colliding() and _velocity_up <= 5:
		_snap_collision = move_and_collide(-PLAYER_SIZE * (snap_distance + 1) * up_direction)
		if _snap_collision:
			up_direction = _snap_collision.get_normal()
			rotation = - up_direction.angle_to(Vector2.UP)
		_is_on_floor = true
	else :
		_is_on_floor = false
		


func _validate_property(property):
	if not Engine.is_editor_hint() :
		return
	if property.name == "Floor":
		property.usage &= ~PROPERTY_USAGE_GROUP
	if property.name in ["floor_snap_length", "motion_mode", "up_direction", "floor_constant_speed", "floor_block_on_wall", "floor_stop_on_slope", "floor_max_angle", "slide_on_ceiling"]:
		property.usage &= ~PROPERTY_USAGE_EDITOR

func _get_property_list():
	return [
		{
			name = "layer", 
			type = 2, 
			hint = 8, 
			hint_string = "", 
			usage = 6,
		}
	]


