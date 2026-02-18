extends AbstractInteractionObject

@onready var global = get_node("/root/Global")
@onready var soundFX = $AudioStreamPlayer3D
@onready var subViewport: SubViewport = $ShopScreenViewport
@onready var screenContent: MeshInstance3D = $ScreenContents

@onready var startSoundFX = preload("res://Assets/Sound/FX/UpgradeComputerStartup.mp3")
@onready var idleSoundFX = preload("res://Assets/Sound/FX/UpgradeComputerIdle.mp3")

var targetPlayerNode: Node3D

func _ready() -> void:
	screenContent.hide()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if isBeenActivated():
		soundFX.set_stream(startSoundFX)
		soundFX.set_playing(true)
		soundFX.get_stream().set_loop(false)
		subViewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
		screenContent.material_override.albedo_texture = subViewport.get_texture()
		screenContent.show()
	
		if not soundFX.is_playing():
			soundFX.set_stream(idleSoundFX)
			soundFX.set_playing(true)
			soundFX.get_stream().set_loop(true)

func _on_audio_stream_player_3d_finished() -> void:
	if not beenActivated:
		soundFX.set_stream(idleSoundFX)
		soundFX.set_playing(true)
		soundFX.get_stream().set_loop(true)

func _on_shop_close_notify() -> void:
	global.writeUpgradeData()

func _on_close_gui() -> void:
	setActive(false)

func _on_open_gui() -> void:
	setActive(true)
