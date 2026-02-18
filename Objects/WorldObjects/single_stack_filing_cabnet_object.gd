extends StaticBody3D

@onready var animationPlayer: AnimationPlayer = $blockbench_export/AnimationPlayer

enum Animations {
	Closing,
	Opening,
	None
}

@export var currentAnimation = Animations.None 

func _ready() -> void:
	var animString = getAnimationName()
	if animString == "":
		return

	animationPlayer.play(animString)

func getAnimationName() -> String:
	match (currentAnimation): 
		Animations.Closing:
			return "TopDrawClose"
		Animations.Opening:
			return "TopDrawOpen"
		_:
			return ""
			
