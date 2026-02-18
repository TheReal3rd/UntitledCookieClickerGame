extends Node3D

@onready var global: Node = $"/root/Global"
@onready var light: OmniLight3D = $OmniLight3D
@onready var explosionViewport: SubViewport = $ExplosionTexViewport
@onready var viewportMesh: MeshInstance3D = $MeshViewport

var originalScale: Vector3 = Vector3.ZERO
var targetScale: Vector3 = Vector3.ZERO
var speed: float = 100.0
var downSizing: bool = false

func _ready() -> void:
	explosionViewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	viewportMesh.material_override.albedo_texture = explosionViewport.get_texture()
	originalScale = scale
	targetScale = Vector3(15.0, 15.0, 15.0)


func _process(delta: float) -> void:
	scale = scale.move_toward(targetScale, speed * delta)
	light.omni_range = move_toward(light.omni_range, 105, speed * delta)
	
	var player: playerObject = global.getPlayer()
	if player:
		look_at(player.get_global_position())
		
	if scale == targetScale:
		queue_free()


func _on_damage_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_damage_area_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_screen_effect_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_screen_effect_area_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
