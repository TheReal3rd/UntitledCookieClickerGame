class_name playerCamera extends Camera3D

@onready var hudShader: ColorRect = $CameraOverlays/HUD/HudShader

var playerYaw: float = 0 : set = setYaw, get = getYaw
var playerPitch: float = 0 : set = setPitch, get = getPitch

#Screen Shacking
var screenShack: bool = false
var shackMaxDuration: int = -1
var shackTimer: int = 0
var shackToggle: bool = false
var finishedReset: bool = true
var shackOffset: Vector3 = Vector3(5.0, 10.0, 10.0) 

#Screen Shader
var shaderMaxDuration: int = -1
var shaderTimer: int = 0
const ogNoiseStrength: float = 0.048
const ogDistortStrength: float = 0.1
const ogGhostStrength: float = 0.12
var shaderUpdate: bool = false : get = isShaderUpdate

var noiseStrength: float = ogNoiseStrength : set = setNoiseStrength
var distrotionStrength: float = ogDistortStrength : set = setDistortionStrength
var ghostStrength: float = ogGhostStrength : set = setGhostStrength

@warning_ignore("unused_signal")
signal submitShaderChange(nStrength: float, dStrength: float, gStrength:float, duration:int)
@warning_ignore("unused_signal")
signal submitShackChange(duration:int)

func _process(delta: float) -> void:
	if shaderUpdate:
		hudShader.material.set_shader_parameter("noise_strength", noiseStrength)
		hudShader.material.set_shader_parameter("distortion_strength", distrotionStrength)
		hudShader.material.set_shader_parameter("ghost_strength", ghostStrength)
		shaderUpdate = false
		
	if shaderMaxDuration != -1 and !shaderUpdate:
		if Time.get_ticks_msec() - shaderTimer >= shaderMaxDuration:
			resetShader()
	
	if screenShack:
		if Time.get_ticks_msec() - shackTimer >= shackMaxDuration:
			screenShack = false
			finishedReset = false
				
		if shackToggle:
			rotation_degrees = rotation_degrees.move_toward(shackOffset, 120 * delta)
			if rotation_degrees.z >= shackOffset.z - 1:
				shackToggle = false
				
		elif not shackToggle:
			rotation_degrees = rotation_degrees.move_toward(shackOffset * -1, 120 * delta)
			if rotation_degrees.z <= (shackOffset.z * -1) + 1:
				shackToggle = true
	else:
		if not finishedReset:
			rotation_degrees = rotation_degrees.move_toward(Vector3(playerPitch, 0, 0), 110 * delta)
			if rotation_degrees.x == playerPitch:
				finishedReset = true


func setYaw(newYaw: float) -> void:
	playerYaw = newYaw
	
func getYaw() -> float:
	return playerYaw
	
func setPitch(newPitch: float) -> void:
	rotation_degrees.x = newPitch
	playerPitch = newPitch
	
func getPitch() -> float:
	return playerPitch
	
func setNoiseStrength(newNoise: float) -> void:
	noiseStrength = newNoise
	shaderUpdate = true
	
func setDistortionStrength(newDistortion: float) -> void:
	distrotionStrength = newDistortion
	shaderUpdate = true
	
func setGhostStrength(newGhost: float) -> void:
	ghostStrength = newGhost
	shaderUpdate = true

func resetShader() -> void:
	noiseStrength = ogNoiseStrength
	distrotionStrength = ogDistortStrength
	ghostStrength = ogGhostStrength
	shaderUpdate = true

func isShaderUpdate() -> bool:
	return shaderUpdate

func _on_submit_shader_change(nStrength: float, dStrength: float, gStrength: float, duration: int) -> void:
	shaderMaxDuration = duration
	shaderTimer = Time.get_ticks_msec()
	noiseStrength = nStrength
	distrotionStrength = dStrength
	ghostStrength = gStrength
	shaderMaxDuration = duration


func _on_submit_shack_change(duration: int) -> void:
	shackMaxDuration = duration
	shackTimer = Time.get_ticks_msec()
	screenShack = true
