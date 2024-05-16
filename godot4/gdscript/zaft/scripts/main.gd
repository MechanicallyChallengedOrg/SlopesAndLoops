class_name MainScene extends CanvasLayer

@onready var background: CanvasLayer = $Background
@onready var level: CanvasLayer = $Level
@onready var pickups: CanvasLayer = $Pickups
@onready var hud: CanvasLayer = $HUD
@onready var menu: CanvasLayer = $Menu
@onready var debug: CanvasLayer = $Debug

const DEMO_BACKGROUND = preload('res://scenes/background.tscn')
const DEMO_LEVEL = preload('res://scenes/level.tscn')
const DEMO_PLAYER = preload('res://scenes/player.tscn')
const DEMO_CAMERA = preload('res://scenes/camera.tscn')

@onready var demo_level = DEMO_LEVEL.instantiate()
@onready var demo_background : BackgroundScene = DEMO_BACKGROUND.instantiate()
@onready var demo_player : PlayerCharacterScene = DEMO_PLAYER.instantiate()
@onready var demo_camera : MainCameraScene = DEMO_CAMERA.instantiate()

func _ready() -> void:
  demo_camera.follow_node = demo_player
  demo_background.follow_node = demo_player
  background.add_child(demo_background)
  demo_player.position = Vector2.UP * 256.0
  level.add_child(demo_level)
  level.add_child(demo_player)
  level.add_child(demo_camera)

