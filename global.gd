extends Node

@onready var globalUtils: Node = get_node("/root/GlobalUtils")

@onready var debugMenuPath = preload("res://DebugAndTesting/TestingWindow.tscn")
var debugMenuOpen: bool = false : set = setDebugMenuState, get = isDebugMenuOpen

var VERSION:String = "1.0" : get = getVersion

const playerSavePath: String = "user://playerData.json"
const settingSavePath: String = "user://settingData.json"

var cookie: Node3D : get = getCookie, set = setCookie
var player: Node3D : get = getPlayer, set = setPlayer
var cookieScore:int = 0 : get = getScore, set = setScore
var cookieProdPerClick: int = 0 : get = getProdPerClick
var poisonTotal:int = 0 : get = getPoisenLevel

#TODO move upgrades to its own manager.
var upgradeManager: UpgradeManager : get = getUpgradeManager
var questManager: QuestManager : get = getQuestManager
var timeDateManager: TimeDateManger : get = getTimeDateManager
var flagTracker: FlagTracker : get = getFlagTracker

var gameStarted: bool = false : get = isGameStarted

var settings: Array[Setting] = [
	Setting.new("ShowFPS", false, Callable.create(self, "voidNothing")),
	Setting.new("FullScreen", false, Callable.create(self, "updateFullscreen"))
] : get = getSettings

#Does nothing. For settings with no callables needed.
@warning_ignore("unused_parameter")
func voidNothing(settingValue) -> void:
	pass

func _ready() -> void:
	readSettingData(true)

func startGame() -> void:
	upgradeManager = UpgradeManager.new(self, globalUtils)
	questManager = QuestManager.new(self, globalUtils)
	timeDateManager = TimeDateManger.new()
	flagTracker = FlagTracker.new()
	
	gameStarted = true
	
func updateFullscreen(settingValue):
	if settingValue:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveGame()
		get_tree().quit()  

func playerIsReady() -> void:
	if questManager:
		questManager.playerIsReady()

func writePlayerData() -> void:
	if not gameStarted:
		return
	
	var file = FileAccess.open(playerSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = player.getSaveData()
		data.set("CookiesScore", cookieScore)
		
		var clockData: Dictionary = timeDateManager.buildSaveDict()
		data.merge(clockData)
		
		var jsonString = JSON.stringify(data)
		file.store_string(jsonString)
		file.close()
		print("Player Data Saved.")
		
func readPlayerData(allowDataWrite:bool=false) -> void:
	if not FileAccess.file_exists(playerSavePath):
		print("Player Data Saved.")
		if allowDataWrite:
			writePlayerData()
		return
		
	var file = FileAccess.open(playerSavePath, FileAccess.READ)
	if file:
		var jsonString: String = file.get_as_text()
		var parsed = JSON.parse_string(jsonString)
		var saveData: Dictionary = {}
		if typeof(parsed) == TYPE_DICTIONARY:
			saveData = parsed
			print("Player data loaded: ", saveData)
		else:
			printerr("Error: The Save file is not a dictionary?!")
			writePlayerData()
		file.close()
		
		if saveData.has("CookiesScore"):
			cookieScore = int(saveData.get("CookiesScore"))
		
		if timeDateManager:
			timeDateManager.loadSavedData(saveData)
			
		player.setSaveData(saveData)

func convertSetting() -> Dictionary:
	var results: Dictionary = {}
	for setting in settings:
		results.set(setting.getName(), setting.getValue())
	return results

func writeSettingData() -> void:
	var file = FileAccess.open(settingSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = convertSetting()
		var jsonString = JSON.stringify(data)
		file.store_string(jsonString)
		file.close()
		print("Setting Data Saved.")

func readSettingData(allowDataWrite:bool=false) -> void:
	if not FileAccess.file_exists(settingSavePath):
		print("Setting Data Saved.")
		if allowDataWrite:
			writeSettingData()
		return
		
	var file = FileAccess.open(settingSavePath, FileAccess.READ)
	if file:
		var jsonString: String = file.get_as_text()
		var parsed = JSON.parse_string(jsonString)
		var saveData: Dictionary = {}
		if typeof(parsed) == TYPE_DICTIONARY:
			saveData = parsed
			print("Setting data loaded: ", saveData)
		else:
			printerr("Error: The Save file is not a dictionary?!")
			writeSettingData()
		file.close()
		
		for setting in settings:
			if not saveData.has(setting.getName()):
				continue
				
			var dict = saveData[setting.getName()]
			setting.setValue(dict)

# Operations

func cookieClick():
	player.emit_signal("updateShopElements")
	#questManager.executeChecks()
	var value:int = 1
	for upgrade in upgradeManager.getUpgrades().values():
		if upgrade.getLevel() <= 0:
			continue
		value = upgrade.onClickAction(value, self)
		cookieProdPerClick = value
	changeScore(value)
	
func getProdPerClick() -> int:
	return cookieProdPerClick
	
func actionExecution():
	player.emit_signal("updateShopElements")
	#questManager.executeChecks()
	var value: int = 0
	var tempPoisenLevel: int = 0
	for upgrade: UpgradeAbstract in upgradeManager.getUpgrades().values():
		if upgrade.getLevel() <= 0:
			continue
		value += upgrade.executeAction(self)
		tempPoisenLevel += upgrade.getPoisenLevel()
	changeScore(value)
	poisonTotal = tempPoisenLevel

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if questManager:
		questManager.executeChecks()
		
	if Input.is_key_pressed(KEY_F3) and Input.is_key_pressed(KEY_D) and not isDebugMenuOpen():
		setDebugMenuState(true)
		var debugWindowInst = debugMenuPath.instantiate()
		get_tree().root.add_child(debugWindowInst)

# Fetching and Setters

func getPlayer():
	return player
func setPlayer(newPlayer):
	player = newPlayer

func getCookie():
	return cookie
func setCookie(newCookie):
	cookie = newCookie

func getScore():
	return cookieScore
func setScore(newScore):
	cookieScore = newScore
func changeScore(amount):
	setScore(cookieScore + amount)


func getPoisenLevel() -> int:
	return poisonTotal
	
func getVersion() -> String:
	return VERSION

func getQuestManager() -> QuestManager:
	return questManager

func getUpgradeManager() -> UpgradeManager:
	return upgradeManager
	
func getTimeDateManager() -> TimeDateManger:
	return timeDateManager

func getSettings() -> Array:
	return settings

func getSettingByName(nameSearch:String) -> Setting:
	for setting in settings:
		if setting.getName() == nameSearch:
			return setting
	return null

func isGameStarted():
	return gameStarted
	
func isDebugMenuOpen():
	return debugMenuOpen
	
func setDebugMenuState(newState: bool):
	debugMenuOpen = newState

func saveGame() -> void:
	writeSettingData()
	writePlayerData()
	if upgradeManager:
		upgradeManager.writeUpgradeData()
	if flagTracker:
		flagTracker.writeFlagData()
	if questManager:
		questManager.writeQuestData()

func exitGame() -> void:
	saveGame()
	get_tree().free()
	
func resetGame() -> void:
	if not gameStarted:
		return
	
	setScore(0)
	if player:
		player.resetPlayer()
	if questManager:
		questManager.resetQuestData()
	writePlayerData()
	upgradeManager.writeUpgradeData()
	questManager.writeQuestData()
	timeDateManager.randomizeDateAndTime()
	flagTracker.reset()
	
func getFlagTracker() -> FlagTracker:
	return flagTracker
