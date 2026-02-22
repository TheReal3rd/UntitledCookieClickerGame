extends StaticBody3D

@onready var animationPlayer: AnimationPlayer = $BomberPlaneModel/AnimationPlayer
@onready var bombPoint1: Node3D = $BombPoint1
@onready var bombPoint2: Node3D = $BombPoint2

const bombObjectPath := preload("res://Objects/WorldObjects/BomberPlane/500KGBomb/500KGBombObject.tscn") 
var bombObject1: Bomb500kgObject
var bombObject2: Bomb500kgObject
var bombDropped1: bool = true
var bombDropped2: bool = true
var isReady: bool = false
var pathFollowNode: PathFollow3D
var prevPosition: Vector3 = Vector3.ZERO
var prevUpdateIntervals: int = 0

enum PlaneAnimations {
	ProppellerSpinGearDown,
	ProppellerSpinGearUp,
	PlayGearUp,
	PlayGearDown,
	InstantGearDown,
	InstantGearUp,
	None
}

@export var staticObject: bool = false
@export var playingAnimation: PlaneAnimations = PlaneAnimations.ProppellerSpinGearUp
@export var numberOfBombs: int = 2
@export var pathingSpeed:float = 0.001
@export var dropProgressRatio:float = -1
@export var resetBombOnLoop: bool = true

func _ready() -> void:
	playAnimation()
	numberOfBombs = clamp(numberOfBombs, 0, 2)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not isReady:
		attachBombs()
		isReady = true
	else:
		if bombObject1 and not bombDropped1:
			bombObject1.set_global_position(bombPoint1.get_global_position())
			bombObject1.set_rotation_degrees(get_rotation_degrees() + Vector3(0,0,-90))
			
		if bombObject2 and not bombDropped2:
			bombObject2.set_global_position(bombPoint2.get_global_position())
			bombObject2.set_rotation_degrees(get_rotation_degrees() + Vector3(0,0,-90))
	
	if not staticObject:
		if Time.get_ticks_msec() - prevUpdateIntervals >= 100:
			prevUpdateIntervals = Time.get_ticks_msec()
			prevPosition = get_global_position()
				
		if get_parent() is PathFollow3D and not pathFollowNode:
			pathFollowNode = get_parent()
		else:
			if pathFollowNode:
				pathFollowNode.progress_ratio += pathingSpeed
				if pathFollowNode.progress_ratio >= dropProgressRatio:
					var globalPos:Vector3 = get_global_position() 
					var bombValocity: Vector3 = Vector3((globalPos.x - prevPosition.x) / 100, -0.1, (globalPos.z - prevPosition.z) / 100)
					if bombObject1 and not bombDropped1:
						bombObject1.setFalling(true)
						bombObject1.setExplode(true)
						bombObject1.setVelocity(bombValocity)
						bombDropped1 = true
						
					if bombObject2 and not bombDropped2:
						bombObject2.setFalling(true)
						bombObject2.setExplode(true)
						bombObject2.setVelocity(bombValocity)
						bombDropped2 = true
				if pathFollowNode.progress_ratio <= dropProgressRatio:
					attachBombs()
	
	if not animationPlayer.is_playing():
		match (playingAnimation):
			PlaneAnimations.ProppellerSpinGearDown:
				animationPlayer.play("ProppellerSpin")
			PlaneAnimations.ProppellerSpinGearUp:
				animationPlayer.play("ProppellerSpinGearsUp")
			PlaneAnimations.PlayGearUp:
				playingAnimation = PlaneAnimations.ProppellerSpinGearUp
			PlaneAnimations.PlayGearDown:
				playingAnimation = PlaneAnimations.ProppellerSpinGearDown
		
		playAnimation()

func playAnimation() -> void:
	match (playingAnimation):
		PlaneAnimations.ProppellerSpinGearDown:
			animationPlayer.play("ProppellerSpin")
		PlaneAnimations.ProppellerSpinGearUp:
			animationPlayer.play("ProppellerSpinGearsUp")
		PlaneAnimations.PlayGearUp:
			animationPlayer.play("LandingGearOpen")
		PlaneAnimations.PlayGearDown:
			animationPlayer.play("LandingGearClosing")
		PlaneAnimations.InstantGearDown:
			animationPlayer.play("LandingGearOpenInstant")
		PlaneAnimations.InstantGearUp:
			animationPlayer.play("LandingGearClosingInstant")
		PlaneAnimations.None:
			animationPlayer.play("LandingGearOpenInstant")

func attachBombs() -> void:
	if not bombDropped1 or not bombDropped2:
		return
	
	if numberOfBombs == 2:
		bombObject1 = bombObjectPath.instantiate()
		if bombObject1:
			get_tree().root.add_child(bombObject1)
			bombObject1.set_global_position(bombPoint1.get_global_position())
			bombObject1.set_rotation_degrees(get_rotation_degrees() + Vector3(0,0,-90))
			bombDropped1 = false
		
		bombObject2 = bombObjectPath.instantiate()
		if bombObject2:
			get_tree().root.add_child(bombObject2)
			bombObject2.set_global_position(bombPoint2.get_global_position())
			bombObject2.set_rotation_degrees(get_rotation_degrees() + Vector3(0,0,-90))
			bombDropped2 = false
	elif numberOfBombs == 1:
		if randi_range(0, 1) == 1:
			bombObject1 = bombObjectPath.instantiate()
			if bombObject1:
				get_tree().root.add_child(bombObject1)
				bombObject1.set_global_position(bombPoint1.get_global_position())
				bombObject1.set_rotation_degrees(get_rotation_degrees() + Vector3(0,0,-90))
				bombDropped1 = false
		else:
			bombObject2 = bombObjectPath.instantiate()
			if bombObject2:
				get_tree().root.add_child(bombObject2)
				bombObject2.set_global_position(bombPoint2.get_global_position())
				bombObject2.set_rotation_degrees(get_rotation_degrees() + Vector3(0,0,-90))
				bombDropped2 = false
			
			
			
			
