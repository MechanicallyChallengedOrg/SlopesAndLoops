class_name DebugScene extends Control

# (i) INFO (i)
# These child nodes are being cached/exposed here because
# other parts of the game interact with them.
# ---
# Namely:
# The debugger node updates player's stats/input in real time,
# as well as being able to enter "gotta go fast" mode
# and show/hide the telemetry/input UIs.
# ---
# This is an alternative for exposing the nodes via unique IDSs
# and it has PROs and CONs. How you expose (or not) internal
# nodes in a scene to other parts of the game is one of those things
# where there are many many many ways of doing it,
# be sure to experiment and find what works for you!

@onready var godot_godot_fast: CheckButton = $TopLeft/VBox/GodotGodotFast
@onready var telemetry: CheckButton = $TopLeft/VBox/Telemetry
@onready var player_stats: Label = $TopLeft/VBox/PlayerStats
@onready var input: CheckButton = $TopLeft/VBox/Input
@onready var player_input: Label = $TopLeft/VBox/PlayerInput

@onready var bgm_value: Label = $TopLeft/VBox/BGM/Value
@onready var bgm_slider: HSlider = $TopLeft/VBox/BGM/Slider
@onready var sfx_value: Label = $TopLeft/VBox/SFX/Value
@onready var sfx_slider: HSlider = $TopLeft/VBox/SFX/Slider
@onready var master_value: Label = $TopLeft/VBox/Master/Value
@onready var master_slider: HSlider = $TopLeft/VBox/Master/Slider

func _ready() -> void:
  bgm_slider.value_changed.connect(__audio.on_bgm_volume_changed.bind(bgm_value))
  sfx_slider.value_changed.connect(__audio.on_sfx_volume_changed.bind(sfx_value))
  master_slider.value_changed.connect(__audio.on_master_volume_changed.bind(master_value))
