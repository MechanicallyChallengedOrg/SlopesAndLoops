class_name GlobalConfig extends Node

# Decimal point rouding for debug telemetry views
const DEBUG_SNAPV := Vector2(0.1, 0.1)
const DEBUG_SNAPF := 0.1

# Godot Character Physics parameters
const MAX_SLOPE_ANGLE := deg_to_rad(80)
const SNAP_LENGTH := 1.5
const MAX_SLIDES := 8

# Animation skew intensity
const SKEW_ANGLE_MAX := deg_to_rad(5)
const SKEW_PER_SEC := 50.0

# Visibility if the loop collision is on or not
const ALPHA_MULTIPLIER_LOOP_OFF := 0.5
const ALPHA_MULTIPLIER_LOOP_ON := 1.0

enum BIT_LAYER {
  None = 0,
  Default = 1,
  Player = 2,
  Terrain = 4,
  Loop = 8,
  Death = 16
}
