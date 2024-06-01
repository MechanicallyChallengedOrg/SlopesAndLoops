class_name LoopPrisonScene extends Node2D

@onready var polygons : Node2D = $Polygons
@onready var bodies := PolygonColliderSetupNode.new()

var wall_left_body : LoopyStaticBody2D
var wall_right_body : LoopyStaticBody2D
var ground_body : LoopyStaticBody2D
var ceiling_body : LoopyStaticBody2D

func _ready() -> void:
  add_child(bodies)
  bodies.copy_polygons_to_bodies(polygons)
  __util.read_bodies_and_polies(self, bodies, polygons)
  if wall_left_body != null : wall_left_body.loop_collision_can_be_disabled = false
  if wall_right_body != null : wall_right_body.loop_collision_can_be_disabled = false
  if ground_body != null : ground_body.loop_collision_can_be_disabled = false
  if ceiling_body != null : ceiling_body.loop_collision_can_be_disabled = false

