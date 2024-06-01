@tool
extends StaticBody2D
class_name LayeredStaticObstacle
## This is an obstacle generated automatically from a [Curve2D]
##
## This is an [StaticBody2D] with both visuals and collision setup automatically from a [Curve2D]. 


## The thickness of obstacle perpendicular to the [member curve]. The thickness is placed on the right of the path when following the path. Try to avoid making it too thin to avoid clipping through floors when droping rapidly on the floor.
@export var floor_thickness : float = 40
## The Curve resource idincating the path that the obstacle should follow. <br> <b>Note : <\b> In case of high curvature to the right with high thickness the polygon decomposition might fail which will result in either or both visual or collsiion to not work properly.
@export var curve : Curve2D :
	set(value):
		curve = value
		if _path :
			_path.curve = curve
var _path : Path2D
var _polygon_colision : CollisionPolygon2D
var _polygon_visual : Polygon2D

var _points_cache : PackedVector2Array :
	set(value):
		if _points_cache == value :
			return 
		_points_cache = value
		_queue_generate_polygons()


## This is the layer of this Obstacles.  For more information about layers see [SlopeBody2D].
var layer : int = 1:
	set(value):

		if value != layer:			# the new layer is the layer in value that is not the old layer
			layer = value & ~ layer 
		# if you deselect the layer nothing happens
		if value :
			z_index = -layer
			collision_layer = layer
			collision_mask = layer


func _ready():
	_polygon_colision = CollisionPolygon2D.new()
	add_child(_polygon_colision)
	_polygon_visual = Polygon2D.new()
	add_child(_polygon_visual)
	if Engine.is_editor_hint():
		for child in get_children():
			if child is Path2D:
				_path = child
		if not _path:
			_path = Path2D.new()
			_path.curve = curve
			add_child(_path, true)
			_path.owner = get_tree().edited_scene_root
	_points_cache = curve.tessellate()
	_generate_polygons()

func _process(delta: float) -> void:
	_points_cache = curve.tessellate()


func _notification(what: int) -> void:
	match what :
		NOTIFICATION_EDITOR_PRE_SAVE:
			_path.owner = null
		NOTIFICATION_EDITOR_POST_SAVE:
			_path.owner = get_tree().edited_scene_root

var _generate_polygons_queued = false
func _queue_generate_polygons():
	if _generate_polygons_queued:
		return
	_generate_polygons_queued = true
	await get_tree().create_timer(1).timeout
	_generate_polygons()

func _generate_polygons():
	_generate_polygons_queued = false
	print("generate polygons")
	if len(_points_cache) < 2:
		return

	var middle_line : PackedVector2Array 
	var bottom_line : PackedVector2Array
	var previous_point : Vector2 = _points_cache[0]
	var current_point : Vector2 = _points_cache[0]
	var next_point : Vector2 = _points_cache[1]
	var down_dir : Vector2 
	var n = len(_points_cache) - 1
	var x 
	var y
	var xt
	var yt
	var sum
	for i in n + 1 :
		match i:
			0:
				down_dir = (next_point - current_point).normalized().rotated(PI/2)
			n:

				down_dir = (current_point - previous_point).normalized().rotated(PI/2)
			_:
				x = (current_point - previous_point).normalized()
				y = (next_point - current_point).normalized()
				xt = x.rotated(PI/2) 
				yt = y.rotated(PI/2)
				sum = x + y
				down_dir = xt + (yt-xt).dot(sum)/sum.length_squared() * x

		middle_line.append(current_point + down_dir * floor_thickness / 4)
		bottom_line.append(current_point + down_dir * floor_thickness)
		previous_point = current_point
		current_point = next_point
		if i+2 < len(_points_cache):
			next_point = _points_cache[i+2]
	middle_line.reverse()
	bottom_line.reverse()
	_polygon_colision.polygon = _points_cache + bottom_line
	_polygon_visual.polygon = _points_cache + bottom_line + _points_cache + middle_line 
	_polygon_visual.polygons = [range(2 * len(_points_cache)), range(2 * len(_points_cache), 4 * len(_points_cache))]
	var green := PackedColorArray()
	green.resize(2 * len(_points_cache))
	green.fill(Color.DARK_GREEN)
	var brown := PackedColorArray()
	brown.resize(2 * len(_points_cache))
	brown.fill(Color.SADDLE_BROWN)
	_polygon_visual.vertex_colors = brown + green

func _get_property_list():
	var result = [
		{
			name = "layer", 
			type = 2, 
			hint = 8, 
			hint_string = "", 
			usage = 6,
		}
	]	
	return result 


func _validate_property(property):
	if not Engine.is_editor_hint():
		return
	if property.name in ["collision_layer", "collision_mask"]:
		property.usage &= ~PROPERTY_USAGE_EDITOR 
	
	if property.name == &"curve":
		property.usage |= PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT

