extends StaticBody3D

@onready var animationPlayer: AnimationPlayer = $blockbench_export/AnimationPlayer

func _ready() -> void:
	animationPlayer.play("BrainFloatingAnimation")


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not animationPlayer.is_playing():
		animationPlayer.play("BrainFloatingAnimation")
