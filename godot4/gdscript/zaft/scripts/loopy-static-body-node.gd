class_name LoopyStaticBody2D extends StaticBody2D

# Matching polygon associated with this body,
# the polygon is the visual representation, the body is the physics logic
# in a proper game you'd probably either have a whole setup for terrain or
# use tilesets.
# If you are thinking in a tiles metaphor, the "poly" here is the tile,
# while this class (the body) is the physics layer collider setup for that tile
@export var poly : Polygon2D

# Enables/Disables the "player can go through when jumping on a slope" functionality
# on regular slopes you want to turn this off, while for the walls of a loop, you want to turn this on
# this is setup incorrectly on purpose in the prison demo level
@export var loop_collision_can_be_disabled := true

func enable_loop_collision():
  collision_layer = __config.BIT_LAYER.Loop
  set_alpha_multiplier_parameter_on_polygon(__config.ALPHA_MULTIPLIER_LOOP_ON)

func disable_loop_collision() -> bool:
  if not loop_collision_can_be_disabled: return false
  collision_layer = __config.BIT_LAYER.None
  set_alpha_multiplier_parameter_on_polygon(__config.ALPHA_MULTIPLIER_LOOP_OFF)
  return true

# I'm using a shader for the polygons, that includes an alpha control
# This is purely to illustrate when the collision for walls of the loop is on/off
func set_alpha_multiplier_parameter_on_polygon(alpha:float=1.0, p:Polygon2D=poly):
  if p == null: return
  var m := p.material as ShaderMaterial
  if m != null: m.set_shader_parameter("alpha_multiplier", alpha)
