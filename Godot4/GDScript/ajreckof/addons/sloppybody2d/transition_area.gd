
@tool
extends Area2D
class_name TransitionArea2d
## This an area that enables transitioning from one layer to another. 
##
## Beware that the area should be thick enough so that the [SlopeBody2D] cannot go from one side to the other side in one frame, In case it does it the area will not detect the player entering hence he will not be transitioned to the new layer.




## This is a vector pointing from where the [SlopeBody2D] should be in [member entry_layer] to where it should be in [member exit_layer]
@export var direction : Vector2 = Vector2.RIGHT :
	set(value):
		direction = value
		if _raycast_direction :
			_raycast_direction.target_position = value
	get :
		if _raycast_direction:
			return _raycast_direction.target_position
		else :
			return direction

var _raycast_direction :RayCast2D :
	set(value):
		if value :
			value.target_position = direction
		_raycast_direction = value

## the layer in which the [SlopeBody2D] should be when exiting the area in the direction opposite to the one pointed by [member direction]. For more information about layers see [SlopeBody2D].
var entry_layer : int = 1:
	set(value):
		if value == entry_layer:
			return
		# if you deselect the layer nothing happens
		if value :
			# the new layer is the layer in value that is not the old layer
			entry_layer = value & ~ entry_layer 
			collision_mask = entry_layer | exit_layer

## the layer in which the [SlopeBody2D] should be when exiting the area in the direction pointed by [member direction]. For more information about layers see [SlopeBody2D].
var exit_layer: int = 2:
	set(value):
		if value == exit_layer:
			return
		# if you deselect the layer nothing happens
		if value :
			# the new layer is the layer in value that is not the old layer
			exit_layer = value & ~ exit_layer 
			collision_mask = entry_layer | exit_layer



func _ready():
	body_exited.connect(_on_body_passed)
	body_entered.connect(_on_body_passed)
	collision_mask = entry_layer | exit_layer
	if Engine.is_editor_hint():
		for child in get_children():
			if child is RayCast2D:
				_raycast_direction = child
		if not _raycast_direction:
			_raycast_direction = RayCast2D.new()
			add_child(_raycast_direction, true)
			_raycast_direction.owner = get_tree().edited_scene_root

func _on_body_passed(body : Node2D):
	if body is SlopeBody2D:
		print("body velocity : ",body.velocity)
		if body.velocity.dot(direction) > 0:
			body.layer = exit_layer
		else :
			body.layer = entry_layer
		print(body.layer)
			

func _get_configuration_warnings() -> PackedStringArray:
	if not _raycast_direction:
		return ["To visually edit the direction you need a Raycast2D. Normally it should create itself when loading the scene."]
	else :
		return []

func _get_property_list():
	return [
		{
			name = "entry_layer", 
			type = TYPE_INT, 
			hint = PROPERTY_HINT_LAYERS_2D_PHYSICS, 
			hint_string = "", 
			usage = PROPERTY_USAGE_DEFAULT,
		},
		{
			name = "exit_layer", 
			type = TYPE_INT, 
			hint = PROPERTY_HINT_LAYERS_2D_PHYSICS, 
			hint_string = "", 
			usage = PROPERTY_USAGE_DEFAULT,
		}
	]

func _validate_property(property):
	if not Engine.is_editor_hint():
		return
	if property.name in ["collision_layer", "collision_mask"]:
		property.usage &= ~PROPERTY_USAGE_EDITOR 


func _notification(what: int) -> void:
	match what :
		NOTIFICATION_EDITOR_PRE_SAVE:
			if _raycast_direction :
				_raycast_direction.owner = null
		NOTIFICATION_EDITOR_POST_SAVE:
			if _raycast_direction :
				_raycast_direction.owner = get_tree().edited_scene_root
