extends StaticBody3D

@onready var global = get_node("/root/Global")
@onready var cookieLabel = $ScoreLabel3D

var floatToOffset: float = 1.5
var startYPosition: float = 0.0
var floatToggle: int = 1

var playerTarget: Node3D

func _ready() -> void:
	global.setCookie(self)
	floatToOffset = 0.15
	startYPosition = position.y
	playerTarget = global.getPlayer()
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not playerTarget:
		playerTarget = global.getPlayer()
		
	cookieLabel.set_text("Cookies: %d" % global.getScore())
	
func _physics_process(delta: float) -> void:
	position.y = lerpf(position.y, startYPosition + (floatToOffset * floatToggle), 0.35 * delta)
	if floor(position.y * 10) >= floor((startYPosition + floatToOffset)  * 10):
		floatToggle = -1
	elif floor(position.y * 10) <= floor((startYPosition - floatToOffset)  * 10):
		floatToggle = 1
	
	look_at(playerTarget.get_global_position())
