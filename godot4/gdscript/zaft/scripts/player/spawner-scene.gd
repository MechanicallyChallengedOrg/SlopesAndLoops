class_name PlayerSpawnerScene extends Node2D

@onready var main : MainScene = get_tree().root.get_node("/root/Main")

func _ready() -> void: spawn_player()

func spawn_player():
  main.demo_player.global_position = global_position
