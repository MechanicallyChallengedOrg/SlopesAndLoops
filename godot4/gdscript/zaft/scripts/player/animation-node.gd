class_name PlayerCharacterAnimationNode extends Node

@onready var player : PlayerCharacterScene = owner

@export var skew_angle_max := PI/8.0
@export var skew_per_frame := 50.0

func animate_player_sprite(delta:float):
  var s : Sprite2D = player.sprite
  var rel_vel := player.velocity.rotated(-player.rotation)
  var skew_fraction : float = abs(rel_vel.x / player.stats.max_vel_ground.x)
  var skew = skew_angle_max * skew_fraction * sign(-rel_vel.x)
  s.skew = lerp(s.skew, skew, delta * skew_per_frame)

func _process(delta: float) -> void:
  animate_player_sprite(delta)
