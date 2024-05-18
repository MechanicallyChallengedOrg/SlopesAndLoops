class_name LoopPrisonScene extends Node2D

@onready var polygons : Node2D = $Polygons
@onready var bodies := PolygonColliderSetupNode.new()

var wall_left_body : StaticBody2D
var wall_right_body : StaticBody2D
var ground_body : StaticBody2D
var ceiling_body : StaticBody2D

func _ready() -> void:
  add_child(bodies)
  bodies.copy_polygons_to_bodies(polygons)
  __util.read_bodies_and_polies(self, bodies, polygons)

