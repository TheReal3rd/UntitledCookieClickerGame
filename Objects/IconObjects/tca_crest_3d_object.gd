extends SubViewport

@onready var sprite: Sprite3D = $Sprite3D
@onready var camera: Camera3D = $Camera3D 

@export var applyFilter: bool = true : set = setFilter
@export var spinning: bool = false
@export var spinSpeed: float = 32.0

enum Crests {
	TCACrest,
	EnergyCrest,
	ArmyCrest,
	MedicinCrest
}

@export var logoSelection: Crests = Crests.TCACrest
var logoTexture: Texture2D

#"#00ff00c8"
func _ready() -> void:
	logoTexture = getImage()
	sprite.set_texture(logoTexture)
	if applyFilter and sprite:
		sprite.set_modulate(Color("#00ff00c8"))

func _physics_process(delta: float) -> void:
	if spinning:
		sprite.rotation_degrees.y += spinSpeed * delta

func setFilter(newFilter):
	applyFilter = newFilter
	if applyFilter and sprite:
		sprite.set_modulate(Color("#00ff00c8"))
		
func getImage():
	var texture: Texture2D
	var texturePath: String = "res://Assets/Texture/Crests/TCA Crest.png"
	match logoSelection:
		Crests.EnergyCrest:
			texturePath = "res://Assets/Texture/Crests/The Ministry of Energy Crest.png"
	
	texture = load(texturePath)
	return texture
