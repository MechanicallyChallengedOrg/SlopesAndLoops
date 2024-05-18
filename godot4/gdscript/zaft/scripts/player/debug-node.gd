class_name PlayerCharacterDebugNode extends Node

const DEBUG = preload('res://scenes/debug.tscn')
@onready var debug_scene : DebugScene = DEBUG.instantiate()
@onready var debug_node := __paths.debug()
@onready var player : PlayerCharacterScene = owner :
  set(p): player = p; set_process(player != null)

func _ready() -> void:
  set_process(player != null)
  debug_node.add_child(debug_scene)
  debug_scene.godot_godot_fast.toggled.connect(on_gotta_go_fast_toggled)

func _process(_delta: float) -> void:
  debug_scene.player_input.text = player.input.to_string()
  debug_scene.player_stats.text = stats_to_string()

func on_gotta_go_fast_toggled(v:bool):
  player.stats.multiplier = 2.0 if v else 1.0
  player.stats.recalculate()

func stats_to_string() -> String:
  return __util.dict_to_debug_str({
    "floor_normal": player.get_floor_normal().snapped(__config.DEBUG_SNAPV),
    "rotation": roundi(rad_to_deg(player.rotation)),
    "up": player.up_direction.snapped(__config.DEBUG_SNAPV),
    "vel_input": "%s %s" % [snapped(player.velocity.length(), __config.DEBUG_SNAPF), player.velocity.snapped(__config.DEBUG_SNAPV)],
    "vel_real": "%s %s" % [snapped(player.get_real_velocity().length(), __config.DEBUG_SNAPF), player.get_real_velocity().snapped(__config.DEBUG_SNAPV)],
    "rays": [player.ray_left_down.is_colliding(), player.ray_center_down.is_colliding(), player.ray_right_down.is_colliding()],
    "jump": "%s (%s)" % [player.stats.jump_time, player.stats.jump_peak],
    "state": "%s => %s" % [player.stats.STATE.find_key(player.stats.state_prev), player.stats.STATE.find_key(player.stats.state)]
  })


