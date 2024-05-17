class_name PlayerCharacterStateAirborneNode extends Node

@onready var player : PlayerCharacterScene = owner

func _ready() -> void:
  player.after_physics_update.connect(may_transition_to_ground)

func _physics_process(delta: float) -> void:
  if player.stats.state != player.stats.STATE.Airborne: return
  physics_process_airborne(delta)

func may_transition_to_ground(_delta:float):
  if player.is_on_floor(): player.stats.state = player.stats.STATE.Grounded

func physics_process_airborne(delta:float):
  var rel_vel := player.velocity.rotated(-player.rotation)
  rel_vel += accel_gravity(delta)
  rel_vel += accel_input(delta)
  rel_vel -= accel_frict(rel_vel,delta)
  rel_vel = rel_vel.clamp(-player.stats.max_vel_air, player.stats.max_vel_air)
  player.velocity = rel_vel.rotated(player.rotation)

  var angle := Vector2.UP.angle_to(player.up_direction)
  var rotation_delta := angle - player.rotation
  if not is_zero_approx(rotation_delta):
    player.up_direction = player.up_direction.rotated(rotation_delta)
    player.rotate(rotation_delta)

func accel_frict(rel_vel:Vector2,delta:float) -> Vector2:
  if not is_zero_approx(player.input.h) or rel_vel.is_zero_approx(): return Vector2.ZERO
  return Vector2.RIGHT * rel_vel.x * player.stats.frict_air.x * delta

func accel_input(delta:float) -> Vector2:
  return Vector2.RIGHT * player.input.h * player.stats.input_accel_air.x * delta

func accel_gravity(_delta:float) -> Vector2:
  return player.stats.g_accel * _delta
