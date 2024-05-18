class_name LoopScene extends Node2D

@onready var polygons : Node2D = $Polygons
@onready var bodies := PolygonColliderSetupNode.new()
var wall_left : StaticBody2D
var wall_right : StaticBody2D

func _ready() -> void:
  add_child(bodies)
  bodies.copy_polygons_to_bodies(polygons)

