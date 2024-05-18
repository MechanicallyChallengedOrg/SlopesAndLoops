class_name ScenicScene extends Node2D

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

# specifying the type of _p here to provoke a crash if layers/masks are wrong
func on_body_entered_activation_zone(_p:PlayerCharacterScene):
  enable_left_wall()
  enable_right_wall()

func enable_left_wall(): __util.enable_wall(wall_left_poly, wall_left_body)
func enable_right_wall(): __util.enable_wall(wall_right_poly, wall_right_body)
func disable_left_wall(): __util.disable_wall(wall_left_poly, wall_left_body)
func disable_right_wall(): __util.disable_wall(wall_right_poly, wall_right_body)

func _ready() -> void:
  activation_zone.body_entered.connect(on_body_entered_activation_zone)
  add_child(bodies)
  bodies.copy_polygons_to_bodies(polygons)
  __util.read_bodies_and_polies(self, bodies, polygons)
  disable_left_wall()
  disable_right_wall()
