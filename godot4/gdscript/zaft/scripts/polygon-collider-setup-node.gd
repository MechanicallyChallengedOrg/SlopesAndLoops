class_name PolygonColliderSetupNode extends Node

@onready var body : StaticBody2D = owner.get_node_or_null("Body")
@onready var poly : Polygon2D = owner.get_node_or_null("Polygon")

func copy_polygon_to_body(b:StaticBody2D=body,p:Polygon2D=poly):
  if b == null or p == null : return
  var c := CollisionPolygon2D.new()
  c.polygon = poly.polygon
  b.add_child(c)
