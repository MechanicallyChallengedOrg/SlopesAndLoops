class_name PlayerCharacterStateInitialNode extends Node

@onready var player : PlayerCharacterScene = owner

func _physics_process(_delta: float) -> void:
  if player.stats.state != player.stats.STATE.Initial: return
  if player.is_on_floor(): player.stats.state = player.stats.STATE.Grounded
  if not player.is_on_floor(): player.stats.state = player.stats.STATE.Airborne
