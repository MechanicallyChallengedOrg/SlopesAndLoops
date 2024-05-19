class_name LoopPickupMarkersNode extends Node2D

@onready var quantity_required_to_unlock := get_child_count()
@onready var tween : Tween

var quantity_picked_up := 0

signal marker_timeout()
signal marker_picked_up(current_count:int,total_required:int)
signal all_markers_picked_up(player:PlayerCharacterScene)

func on_player_picked_up(p:PlayerCharacterScene,m:LoopPickupMarkerScene):
  pick_single_marker(m)
  if (quantity_picked_up >= quantity_required_to_unlock): all_markers_picked_up.emit(p)
  setup_timeout()

# every time the player picks up a loop marker
# the timeout is pushed back by a configured value
func setup_timeout():
  if (tween != null): tween.kill()
  tween = create_tween()
  tween.tween_interval(__config.MARKER_PICKUP_TIMEOUT)
  tween.tween_callback(on_timeout)

# if the player takes too long, all markers are reset
func on_timeout():
  reset_markers()
  marker_timeout.emit()

func reset_markers():
  quantity_picked_up = 0
  for m : LoopPickupMarkerScene in get_children(): setup_single_marker(m)

func _ready() -> void: reset_markers()

func setup_single_marker(m:LoopPickupMarkerScene):
  m.visible = true
  m.area.monitoring = true
  # CONNECT_ONE_SHOT is very important in a situation like this,
  # whenever you connect from a signal from within another signal (or player input)
  # you most likely want to use a "one shot" flag, otherwise you will end up
  # accumulating more and more and more connected listeners every time this goes through
  m.area.body_entered.connect(on_player_picked_up.bind(m), CONNECT_ONE_SHOT)

func pick_single_marker(m:LoopPickupMarkerScene):
  quantity_picked_up += 1
  m.visible = false
  m.area.set_deferred('monitoring', true)
  marker_picked_up.emit(quantity_picked_up, quantity_required_to_unlock)
