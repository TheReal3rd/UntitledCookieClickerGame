extends Node3D

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("TurnLoop")
