class_name AbstractLavel extends Node3D

var playerRef: playerObject

#Level Settings
var resetStuckPlayers: bool = true : set = setResetStuck
var resetMaxFallLevel: float = -40 : set = setResetFallLevel

var levelName: String = "AbstractLevel" : set = setLevelName, get = getLevelName
var savableLocation: bool = false : set = setSavableLevel, get = isSavableLevel

# ID : [ Vector3 (PosX, PosY, PosZ), Vector2 (pitch, yaw) ]
var doorEntryDataDict = {
	0 : [ Vector3(0,0,0) , Vector2(0,0) ]#Always have atleast one entry point. even if its a shitty one.
}

#Override this not the process.
@warning_ignore("unused_parameter")
func levelUpdate(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	levelUpdate(delta)
	if resetStuckPlayers:
		if not playerRef:
			return
			
		var playerPos:Vector3 = playerRef.get_global_position()
		if playerPos.y <= resetMaxFallLevel:
			pass#TODO use the same call to set pos and rot for this reset.
		
func setResetStuck(newState: bool) -> void:
	resetStuckPlayers = newState
	
func setResetFallLevel(newLevel: float) -> void:
	resetMaxFallLevel = newLevel
	
func setLevelName(newName: String) -> void:
	levelName = newName
	
func getLevelName() -> String:
	return levelName
	
func setSavableLevel(savableState: bool) -> void:
	savableLocation = savableState
	
func isSavableLevel() -> bool:
	return savableLocation
