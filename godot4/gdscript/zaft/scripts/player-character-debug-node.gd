class_name PlayerCharacterDebugNode extends Node

const DEBUG = preload('res://scenes/debug.tscn')
@onready var debug_scene : DebugScene = DEBUG.instantiate()
@onready var debug_node := __paths.debug()
@onready var player : PlayerCharacterScene = owner :
  set(p): player = p; set_process(player != null)

func _ready() -> void:
  set_process(player != null)
  debug_node.add_child(debug_scene)
func _process(_delta: float) -> void:
  debug_scene.player_input.text = player.input.to_string()
  debug_scene.player_stats.text = player.stats.to_string()

