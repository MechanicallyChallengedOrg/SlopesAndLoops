class_name PlayerSpawnerScene extends Node2D

@onready var main : MainScene = get_tree().root.get_node("/root/Main")
@onready var death : Area2D = $Death

func _ready() -> void:
  spawn_player()
  death.body_entered.connect(on_body_entered_death_plane)

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action('respawn') and event.is_pressed() and not event.is_echo():
    spawn_player()

func on_body_entered_death_plane(_b:PlayerCharacterScene):
  spawn_player()

func spawn_player():
  main.demo_player.global_position = global_position
  main.demo_player.stats.reset()
