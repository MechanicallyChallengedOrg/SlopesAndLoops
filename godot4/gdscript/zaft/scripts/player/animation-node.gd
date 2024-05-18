class_name PlayerCharacterAnimationNode extends Node

@onready var player : PlayerCharacterScene = owner

func animate_player_sprite(delta:float):
  var s : Sprite2D = player.sprite
  var rel_vel := player.velocity.rotated(-player.rotation)
  var skew_fraction : float = abs(rel_vel.x / player.stats.max_vel_ground.x)
  var skew = __config.SKEW_ANGLE_MAX * skew_fraction * sign(-rel_vel.x)
  s.skew = lerp(s.skew, skew, delta * __config.SKEW_PER_SEC)

func _process(delta: float) -> void:
  animate_player_sprite(delta)
