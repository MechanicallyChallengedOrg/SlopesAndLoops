class_name BackgroundScene extends Control

@onready var rect : TextureRect = $Godot
@onready var mat : ShaderMaterial = rect.material
@export var follow_node : Node2D

func _process(_delta: float) -> void:
  if follow_node == null: return
  mat.set_shader_parameter("target_position", follow_node.position)
  mat.set_shader_parameter("parallax_scale", 0.01)
