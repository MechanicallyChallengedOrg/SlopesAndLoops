class_name GlobalAudio extends Node

@onready var bgm := AudioStreamPlayer.new()
@onready var sfx := AudioStreamPlayer.new()

const SFX_JUMP : AudioStreamWAV = preload('res://assets/jump-godotnic.wav')
const SFX_LAND : AudioStreamWAV = preload('res://assets/land-godotnic.wav')
const BGM_LEOD : AudioStreamMP3 = preload('res://assets/Voxel Revolution.mp3')

func _ready() -> void:
  add_child(bgm)
  add_child(sfx)
  sfx.volume_db = linear_to_db(__config.VOLUME_SFX / 100.0)
  bgm.volume_db = linear_to_db(__config.VOLUME_BGM / 100.0)
  bgm.stream = BGM_LEOD
  bgm.play()
  bgm.finished.connect(bgm.play)


func play_bgm(bgm_stream: AudioStream):
  if (bgm.stream == bgm_stream and bgm.playing): return
  bgm.stream = bgm_stream
  bgm.volume_db = linear_to_db(__config.VOLUME_BGM / 100.0)
  bgm.play()

func play_sfx(sfx_stream: AudioStream, pitch_scale: float = 1.0):
  sfx.stream = sfx_stream
  sfx.pitch_scale = pitch_scale
  sfx.volume_db = linear_to_db(__config.VOLUME_SFX / 100.0)
  sfx.play()

