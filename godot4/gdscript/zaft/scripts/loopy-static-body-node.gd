class_name LoopyStaticBody2D extends StaticBody2D

@export var poly : Polygon2D
@export var loop_collision_can_be_disabled := true

func enable_loop_collision():
  collision_layer = __config.BIT_LAYER.Loop
  set_alpha_multiplier_parameter_on_polygon(__config.ALPHA_MULTIPLIER_LOOP_ON)

func disable_loop_collision() -> bool:
  if not loop_collision_can_be_disabled: return false
  collision_layer = __config.BIT_LAYER.None
  set_alpha_multiplier_parameter_on_polygon(__config.ALPHA_MULTIPLIER_LOOP_OFF)
  return true

func set_alpha_multiplier_parameter_on_polygon(alpha:float=1.0, p:Polygon2D=poly):
  if p == null: return
  var m := p.material as ShaderMaterial
  if m != null: m.set_shader_parameter("alpha_multiplier", alpha)
