class_name GlobalAudio extends Node

@onready var bgm := AudioStreamPlayer.new()
@onready var sfx := AudioStreamPlayer.new()

const SFX_JUMP : AudioStreamWAV = preload('res://assets/jump-godotnic.wav')
const SFX_LAND : AudioStreamWAV = preload('res://assets/land-godotnic.wav')
const SFX_COIN : AudioStreamWAV = preload('res://assets/coin-godotnic.wav')
const BGM_LEOD : AudioStreamMP3 = preload('res://assets/Voxel Revolution.mp3')

func on_sfx_volume_changed(v:int,ui:Label=null):
  sfx.volume_db = linear_to_db(v / 100.0)
  if ui != null: ui.text = "%s" % v

func on_bgm_volume_changed(v:int,ui:Label=null):
  bgm.volume_db = linear_to_db(v / 100.0)
  if ui != null: ui.text = "%s" % v

func on_master_volume_changed(v:int,ui:Label=null):
  AudioServer.set_bus_volume_db(0, linear_to_db(v / 100.0))
  if ui != null: ui.text = "%s" % v

func _ready() -> void:
  add_child(bgm)
  add_child(sfx)
  sfx.volume_db = linear_to_db(0.5)
  bgm.volume_db = linear_to_db(0.5)
  AudioServer.set_bus_volume_db(0, linear_to_db(0.5))
  bgm.stream = BGM_LEOD
  bgm.play()
  bgm.finished.connect(bgm.play)

func play_bgm(bgm_stream: AudioStream):
  if (bgm.stream == bgm_stream and bgm.playing): return
  bgm.stream = bgm_stream
  bgm.play()

func play_sfx(sfx_stream: AudioStream, pitch_scale: float = 1.0):
  sfx.stream = sfx_stream
  sfx.pitch_scale = pitch_scale
  sfx.play()

