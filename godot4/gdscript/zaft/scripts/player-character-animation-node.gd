class_name PlayerCharacterAnimationNode extends Node

@onready var player : PlayerCharacterScene = owner

func animate_player_sprite(delta:float):
  var s : Sprite2D = player.sprite
  var h_axis := player.stats.up.rotated(PI / 2.0)
  var vel_h_axis := player.stats.velocity.project(h_axis)
  var vel_h_axis_len := vel_h_axis.length()
  var vel_ratio_from_max := vel_h_axis_len / player.stats.max_vel_ground.x
  var angle := vel_h_axis.angle_to(h_axis)
  var skew_direction := signf(cos(angle))
  var skew_intensity := -PI/16.0
  var skew_per_frame := 5.0
  s.skew = lerp(s.skew, skew_direction * skew_intensity * vel_ratio_from_max, delta * skew_per_frame)

func _process(delta: float) -> void:
  animate_player_sprite(delta)
