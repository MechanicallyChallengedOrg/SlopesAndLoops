class_name MainCameraScene extends Camera2D

@export var follow_node : Node2D :
  set(n): follow_node = n; set_process(follow_node != null)

@export var follow_speed : float = 10000.0

func _ready() -> void:
  set_process(follow_node != null)

func _process(delta: float) -> void:
  global_position = lerp(global_position, follow_node.global_position, min(follow_speed * delta, 1.0))

func zoom_in():
  var new_zoom := zoom + Vector2.ONE
  zoom = round(new_zoom) if new_zoom.x <= 8 else zoom

func zoom_out():
  var new_zoom := zoom - Vector2.ONE
  zoom = round(new_zoom) if new_zoom.x >= 1 else zoom
