extends StaticBody3D

@onready var interactLabel = $InteractLabel
@onready var global = get_node("/root/Global")
@onready var soundFX = $AudioStreamPlayer3D
@onready var subViewport: SubViewport = $ShopScreenViewport
@onready var screenContent: MeshInstance3D = $ScreenContents

@onready var startSoundFX = preload("res://Assets/Sound/FX/UpgradeComputerStartup.mp3")
@onready var idleSoundFX = preload("res://Assets/Sound/FX/UpgradeComputerIdle.mp3")

var targetPlayerNode: Node3D
var computerStarted: bool = false

@warning_ignore("unused_signal")
signal shopCloseNotify

func _ready() -> void:
	interactLabel.hide()
	screenContent.hide()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not targetPlayerNode:
		targetPlayerNode = global.getPlayer()
	else:
		if get_global_position().distance_to(targetPlayerNode.get_global_position()) <= 2.3 and targetPlayerNode.isShopUnlocked():
			interactLabel.show()
			if Input.is_action_just_pressed("E_Interact"):
				targetPlayerNode.emit_signal("openShopScreen", self)
				if not computerStarted:
					soundFX.set_stream(startSoundFX)
					soundFX.set_playing(true)
					soundFX.get_stream().set_loop(false)
					subViewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
					screenContent.material_override.albedo_texture = subViewport.get_texture()
					screenContent.show()
					computerStarted = true
		else:
			interactLabel.hide()
			
	if computerStarted and not soundFX.is_playing():
		soundFX.set_stream(idleSoundFX)
		soundFX.set_playing(true)
		soundFX.get_stream().set_loop(true)

func _on_audio_stream_player_3d_finished() -> void:
	if not computerStarted:
		soundFX.set_stream(idleSoundFX)
		soundFX.set_playing(true)
		soundFX.get_stream().set_loop(true)

func _on_shop_close_notify() -> void:
	global.writeUpgradeData()
