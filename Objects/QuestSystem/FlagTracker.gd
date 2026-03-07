class_name FlagTracker extends Resource

#Manager and storage location of tracking flag events.
#Such as when a player has completed a task or specific quest actions that can be looked up and checked upon.
const flagSavePath: String = "user://flagData.json"
var flagsDict: Dictionary = {}

# FIRST_INTERACT_MANN_MACHINE - Tutorial quest tracking interact with handler.
# UNLOCKED_SHOP_MACHINE - Tutorial tracking to unlock shop access.
# PLAYER_TERMINAL_UNLOCKED - Player unlock tracking for player terminal.

func _init() -> void:
	readFlagData(true)

func pushFlag(flagName: String, value) -> void:
	flagsDict.set(flagName.to_upper(), value)
	
func fetchFlag(flagName: String):
	if not flagsDict.has(flagName.to_upper()):
		return false
	return flagsDict.get(flagName.to_upper())
	
func writeFlagData() -> void:
	var file = FileAccess.open(flagSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = flagsDict
		var jsonString = JSON.stringify(data)
		file.store_string(jsonString)
		file.close()
		print("Flag Data Saved.")
	
func readFlagData(allowDataWrite:bool=false) -> void:
	if not FileAccess.file_exists(flagSavePath):
		print("Flag Data Saved.")
		if allowDataWrite:
			writeFlagData()
		return
		
	var file = FileAccess.open(flagSavePath, FileAccess.READ)
	if file:
		var jsonString: String = file.get_as_text()
		var parsed = JSON.parse_string(jsonString)
		var data: Dictionary = {}
		if typeof(parsed) == TYPE_DICTIONARY:
			data = parsed
			print("Flag data loaded: ", data)
		else:
			printerr("Error: The flag file is not a dictionary?!")
			writeFlagData()
		file.close()
		
		flagsDict = data
		
func reset():
	flagsDict.clear()
	writeFlagData()
