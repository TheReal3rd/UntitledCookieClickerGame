extends StaticBody3D

@onready var animationPlayer: AnimationPlayer = $blockbench_export/AnimationPlayer

enum Animations {
	TopClosing,
	BottomClosing,
	TopOpening,
	BottomOpening,
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
		Animations.TopClosing:
			return "TopDrawClose"
		Animations.BottomClosing:
			return "BottomDrawClose"
		Animations.TopOpening:
			return "TopDrawOpen"
		Animations.BottomOpening:
			return "BottomDrawOpen"
		_:
			return ""
			
