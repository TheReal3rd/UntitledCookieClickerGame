extends StaticBody3D

@onready var global: Node = $"/root/Global"
@onready var area3D: Area3D = $Area3D

@export var highRadiation: bool = true

func _ready() -> void:
	if not highRadiation:
		area3D.set_monitoring(false)
		area3D.set_process_mode(PROCESS_MODE_DISABLED)

@warning_ignore("unused_parameter")
func _on_area_3d_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	var player: playerObject = global.getPlayer()
	if player:
		player.emit_signal("radioObjectNotifyAdd", self)


@warning_ignore("unused_parameter")
func _on_area_3d_area_shape_exited(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	var player: playerObject = global.getPlayer()
	if player:
		player.emit_signal("radioObjectNotifyRemove", self)
