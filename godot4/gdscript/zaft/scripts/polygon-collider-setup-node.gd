class_name PolygonColliderSetupNode extends Node2D

func copy_polygons_to_bodies(polygons:Node2D):
  for poly in polygons.get_children():
    if not poly is Polygon2D: continue
    var body := StaticBody2D.new()
    add_child(body)
    copy_polygon_to_body(body,poly)

func copy_polygon_to_body(b:StaticBody2D,p:Polygon2D):
  if b == null or p == null : return
  b.global_position = p.global_position
  var c := CollisionPolygon2D.new()
  c.polygon = p.polygon
  b.add_child(c)
