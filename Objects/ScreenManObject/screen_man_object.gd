extends AbstractInteractionObject

@onready var subViewport:SubViewport = $ScreenViewport
@onready var subViewportMesh:MeshInstance3D = $SubViewPortMesh
@onready var soundFX: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	subViewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	subViewportMesh.material_override.albedo_texture = subViewport.get_texture()
	soundFX.set_playing(true)
	soundFX.get_stream().set_loop(true)

func _on_close_gui() -> void:
	setActive(false)

func _on_open_gui() -> void:
	setActive(true)
