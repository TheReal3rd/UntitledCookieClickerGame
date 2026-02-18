class_name Bomb500kgObject extends StaticBody3D

@onready var bombModel: MeshInstance3D = $blockbench_export/cylinder
@onready var bombNode: Node3D = $blockbench_export
@onready var facingPoint: Node3D = $FacingPoint

var cleanTexturePath: String = "res://Assets/Objects/AirBombs/CleanTextureMaterial.tres"
var explosionNodePath: String = "res://Objects/FX/Explosion/explosion.tscn"

enum BombTexture {
	Dirty,
	Clean,
	Random
} 

@export var bombTexture: BombTexture = BombTexture.Random
@export var fallingLogic: bool = false : set = setFalling
@export var explodeOnImpact: bool = false : set = setExplode
@export var velocity: Vector3 = Vector3(0,-0.1,0) : set = setVelocity

var exploding: bool = false
var explodeTimer: int = -1

func _ready() -> void:
	match (bombTexture):
		BombTexture.Clean:
			useCleanTexture()
		BombTexture.Random:
			if randi_range(0, 1) == 1:
				useCleanTexture()
				
func useCleanTexture() -> void:
	var loadTexture = load(cleanTexturePath)
	if loadTexture:
		bombModel.set_surface_override_material(0, loadTexture)

func _physics_process(delta: float) -> void:
	if fallingLogic:
		velocity.x *= 0.999988
		velocity.z *= 0.999988
		velocity.x += randf_range(-0.009, 0.009)
		velocity.z += randf_range(-0.009, 0.009)
		velocity.y = move_toward(velocity.y, -4.5, delta)
		
		facingPoint.set_position(Vector3(get_position().x - velocity.x, facingPoint.get_position().y, get_position().z - velocity.z))
		look_at(facingPoint.get_position())
		rotation_degrees.x += 90
		
		move_and_collide(velocity)
		
	if exploding:
		if Time.get_ticks_msec() - explodeTimer > 3000:
			spawnExplosion()
		
func _on_detonation_area_body_entered(body: Node3D) -> void:
	if body is StaticBody3D and body.is_in_group("WorldObject"):
		velocity = Vector3.ZERO
		fallingLogic = false
		if explodeOnImpact and not exploding:
			exploding = true
			explodeTimer = Time.get_ticks_msec()
				
func spawnExplosion():
	var explosionLoad = load(explosionNodePath)
	if explosionLoad:
		var explosionInstance:Node3D = explosionLoad.instantiate()
		get_tree().root.add_child(explosionInstance)
		explosionInstance.set_global_position(get_global_position())
		queue_free()

func setFalling(newState: bool) -> void:
	fallingLogic = newState
	
func setExplode(newState: bool) -> void:
	explodeOnImpact = newState
	
func setVelocity(newVelocity:Vector3) -> void:
	velocity = newVelocity
