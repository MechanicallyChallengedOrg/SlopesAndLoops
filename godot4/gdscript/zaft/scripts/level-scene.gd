extends Node2D

@onready var level_container: Node2D = $LevelContainer

@onready var prison_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/Prison
@onready var half_pipe_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/HalfPipe
@onready var half_wall_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/HalfWall
@onready var loop_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/Loop
@onready var scenic_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/Scenic

@onready var prison_scene = preload('res://scenes/levels/loop_prison.tscn')
@onready var half_pipe_scene = preload('res://scenes/levels/half_pipe.tscn')
@onready var half_wall_scene = preload('res://scenes/levels/half_pipe_wall.tscn')
@onready var loop_scene = preload('res://scenes/levels/loop.tscn')
@onready var scenic_scene = preload('res://scenes/levels/full.tscn')

func _ready() -> void:
  level_container.add_child(loop_scene.instantiate())
  for k in ["prison", "half_pipe", "half_wall", "loop", "scenic"]:
    var button : Button = get("%s_button" % [k])
    var scene : PackedScene = get("%s_scene" % [k])
    button.pressed.connect(replace_level_scene_with.bind(scene))

func replace_level_scene_with(scene:PackedScene):
  if level_container.get_child_count() > 0:
    for c in level_container.get_children(): c.queue_free()
  level_container.add_child(scene.instantiate())

