class_name cookieObject extends StaticBody3D

@onready var global = get_node("/root/Global")
@onready var cookieLabel: Label3D = $ScoreLabel3D
@onready var clickParticles1: CPUParticles3D = $ClickParticles1
@onready var clickParticles2: CPUParticles3D = $ClickParticles1

var floatToOffset: float = 1.5
var startYPosition: float = 0.0
var floatToggle: int = 1

var playerTarget: playerObject

var productionAmount: int = 0
var particleTimer: int = 0
var particleFlipFlop: bool = false

func _ready() -> void:
	global.setCookie(self)
	floatToOffset = 0.15
	startYPosition = position.y
	playerTarget = global.getPlayer()
	clickParticles1.set_amount(1)
	clickParticles2.set_amount(1)
	clickParticles1.hide()
	clickParticles2.hide()
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not playerTarget:
		playerTarget = global.getPlayer()
		
	if Time.get_ticks_msec() - particleTimer > 1900:
		particleTimer = Time.get_ticks_msec()
		if productionAmount > 0:
			@warning_ignore("integer_division")
			productionAmount -= int(floor(productionAmount / 2))
			particleTimer = Time.get_ticks_msec()
		if particleFlipFlop:
			clickParticles2.set_amount(clamp(productionAmount, 1, 500))
			clickParticles2.hide()
			clickParticles1.show()
			particleFlipFlop = false
		else:
			clickParticles1.set_amount(clamp(productionAmount, 1, 500))
			clickParticles1.hide()
			clickParticles2.show()
			particleFlipFlop = true
		#print(str(productionAmount) + " | " + str(particleFlipFlop))
		
	cookieLabel.set_text("Cookies: %d" % global.getScore())
	
func _physics_process(delta: float) -> void:
	position.y = lerpf(position.y, startYPosition + (floatToOffset * floatToggle), 0.35 * delta)
	if floor(position.y * 10) >= floor((startYPosition + floatToOffset)  * 10):
		floatToggle = -1
	elif floor(position.y * 10) <= floor((startYPosition - floatToOffset)  * 10):
		floatToggle = 1
	
	look_at(playerTarget.get_global_position())
	
func clickEffects(prodAmount: int):
	productionAmount += prodAmount
	
	
	
	
	
	
