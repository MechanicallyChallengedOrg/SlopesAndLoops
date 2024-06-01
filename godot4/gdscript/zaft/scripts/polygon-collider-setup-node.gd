class_name PolygonColliderSetupNode extends Node2D

func copy_polygons_to_bodies(polygons:Node2D):
  for poly in polygons.get_children():
    if not poly is Polygon2D: continue
    var body := LoopyStaticBody2D.new()
    body.name = poly.name
    body.collision_mask = 0
    body.collision_layer = 0
    add_child(body)
    copy_polygon_to_body(body,poly)

func copy_polygon_to_body(b:LoopyStaticBody2D,p:Polygon2D):
  if b == null or p == null : return
  b.poly = p
  b.global_position = p.global_position
  var c := CollisionPolygon2D.new()
  c.polygon = p.polygon
  b.add_child(c)
