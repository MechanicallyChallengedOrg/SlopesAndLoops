class_name GlobalUtil extends Node

func v_only(v:Vector2)->Vector2:return Vector2(0.0, v.y)
func h_only(v:Vector2)->Vector2:return Vector2(v.x, 0.0)
func dict_to_debug_str(d:Dictionary)->String:return var_to_str(d)\
  .replace("{","").replace("}","").replace('"',"").replace(",\n","\n").replace("Vector2", "").strip_edges()

# /!\ DISCLAIMER /!\
# generally having this level of tight coupling with the tree structure
# is a TERRIBLE idea, only doing this here because it's a tiny demo
# if you need to access inner nodes, I'd suggest one of thse (in order):
#   - A) create an explicit accessor in the parent scene
#   - B) take the path as an export
#   - C) give them a unique name
func read_bodies_and_polies(_self:Object,bodies:Node,polygons:Node):
  # /!\ DISCLAIMER /!\
  # using "set" and "get" is generally a terrible idea because it can hide errors
  # I'm only doing this here to remove some boilerplate code from the demo scenes
  # to make them more focused on the mechanics being displayed
  _self.set("wall_left_poly", polygons.get_node_or_null("WallLeft"))
  _self.set("wall_right_poly", polygons.get_node_or_null("WallRight"))
  _self.set("wall_right_2_poly", polygons.get_node_or_null("WallRight2"))
  _self.set("ground_poly", polygons.get_node_or_null("Floor"))
  _self.set("ground_2_poly", polygons.get_node_or_null("Floor2"))
  _self.set("ceiling_poly", polygons.get_node_or_null("Ceiling"))
  _self.set("wall_left_body", bodies.get_node_or_null("WallLeft"))
  _self.set("wall_right_body", bodies.get_node_or_null("WallRight"))
  _self.set("wall_right_2_body", bodies.get_node_or_null("WallRight2"))
  _self.set("ground_body", bodies.get_node_or_null("Floor"))
  _self.set("ground_2_body", bodies.get_node_or_null("Floor2"))
  _self.set("ceiling_body", bodies.get_node_or_null("Ceiling"))
  for k in ["ground_body", "ceiling_body", "ground_2_body"]:
    var v := _self.get(k) as StaticBody2D
    if v != null: v.collision_layer = __config.BIT_LAYER.Terrain
  for k in ["wall_left_body", "wall_right_body", "wall_right_2_body"]:
    var v := _self.get(k) as StaticBody2D
    if v != null: v.collision_layer = __config.BIT_LAYER.Loop

