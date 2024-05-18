class_name LoopScene extends Node2D

@onready var polygons : Node2D = $Polygons
@onready var bodies := PolygonColliderSetupNode.new()
@onready var activation_zone : Area2D = $WallActivationZone

var wall_left_body : StaticBody2D
var wall_right_body : StaticBody2D
var ground_body : StaticBody2D
var ceiling_body : StaticBody2D

var wall_left_poly : Polygon2D
var wall_right_poly : Polygon2D
var ground_poly : Polygon2D
var ceiling_poly : Polygon2D

func on_body_entered_activation_zone(p:PlayerCharacterScene):
  enable_left_wall()
  enable_right_wall()

func enable_left_wall(): enable_wall(wall_left_poly, wall_left_body)
func enable_right_wall(): enable_wall(wall_right_poly, wall_right_body)
func disable_left_wall(): disable_wall(wall_left_poly, wall_left_body)
func disable_right_wall(): disable_wall(wall_right_poly, wall_right_body)

func enable_wall(p:Polygon2D,b:StaticBody2D):
  if p == null or b == null: return
  var m : ShaderMaterial = p.material
  m.set_shader_parameter("alpha_multiplier", 1.0)
  b.collision_layer = __config.BIT_LAYER.Loop

func disable_wall(p:Polygon2D,b:StaticBody2D):
  if p == null or b == null: return
  var m : ShaderMaterial = p.material
  m.set_shader_parameter("alpha_multiplier", 0.1)
  b.collision_layer = __config.BIT_LAYER.None

func _ready() -> void:
  activation_zone.body_entered.connect(on_body_entered_activation_zone)
  add_child(bodies)
  bodies.copy_polygons_to_bodies(polygons)
  wall_left_poly = polygons.get_node("WallLeft")
  wall_right_poly = polygons.get_node("WallRight")
  ground_poly = polygons.get_node("Floor")
  ceiling_poly = polygons.get_node("Ceiling")
  wall_left_body = bodies.get_node("WallLeft")
  wall_right_body = bodies.get_node("WallRight")
  ground_body = bodies.get_node("Floor")
  ceiling_body = bodies.get_node("Ceiling")
  ground_body.collision_layer = __config.BIT_LAYER.Terrain
  ceiling_body.collision_layer = __config.BIT_LAYER.Terrain
  wall_left_body.collision_layer = __config.BIT_LAYER.Loop
  wall_right_body.collision_layer = __config.BIT_LAYER.Loop
  disable_left_wall()
  disable_right_wall()
