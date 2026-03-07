extends StaticBody3D

@onready var cerealBoxMesh: MeshInstance3D = $CerealBoxModel/mesh

enum CerealTextures {
	JammieBrik,
	HellsBits
}

@export var selectedTexture: CerealTextures = CerealTextures.JammieBrik

func _ready() -> void:
	var matOverride: Material
	match (selectedTexture):
		CerealTextures.HellsBits:
			matOverride = load("res://Assets/Objects/CerealBoxs/CerealBox_1_Material.tres")
			cerealBoxMesh.set_surface_override_material(0, matOverride)
