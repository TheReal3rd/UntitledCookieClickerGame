extends SubViewport

@onready var foodObject: Node3D = $Object3D


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var currentRot = foodObject.get_rotation_degrees()
	currentRot.y += 2
	currentRot.x -= 2
	currentRot.z += 2
	foodObject.set_rotation_degrees(currentRot)
