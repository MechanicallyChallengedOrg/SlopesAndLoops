class_name LoopPrisonScene extends Node2D

@onready var body : StaticBody2D = $Body
@onready var poly : Polygon2D = $Polygon

func _ready() -> void:
  var c := CollisionPolygon2D.new()
  c.polygon = poly.polygon
  body.add_child(c)
