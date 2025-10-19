extends Node

var VERSION:String = "1.0" : get = getVersion

const upgradeSavePath: String = "user://upgradeData.json"
const playerSavePath: String = "user://playerData.json"
const settingSavePath: String = "user://settingData.json"

var cookie: Node3D : get = getCookie, set = setCookie
var player: Node3D : get = getPlayer, set = setPlayer
var cookieScore:int = 0 : get = getScore, set = setScore
var poisonTotal:int = 0 : get = getPoisenLevel

var upgrades: Dictionary = {} : get = getUpgrades

var questManager: QuestManager : get = getQuestManager

var settings: Array[Setting] = [
	Setting.new("ShowFPS", false)
] : get = getSettings

func _ready() -> void:
	registerUpgrades()
	readUpgradeData(true)
	questManager = QuestManager.new(self)
	readSettingData(true)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		writeUpgradeData()
		writePlayerData()
		questManager.writeQuestData()
		writeSettingData()
		get_tree().quit()  

func playerIsReady() -> void:
	questManager.playerIsReady()

func listFiles(path: String) -> Array[String]:
	var fileNames: Array[String] = []
	var dir := DirAccess.open(path)
	if dir == null:
		printerr("Error directory wasn't found.")
		return []
	
	dir.list_dir_begin()
	var fileName = dir.get_next()
	while fileName != "":
		if dir.current_is_dir():
			continue
		fileNames.append(fileName)
		fileName = dir.get_next()
	dir.list_dir_end()
	return fileNames

func registerUpgrades() -> void:
	var files: Array[String] = listFiles("res://Objects/Upgrades/Upgrades/")
	for file in files:
		if file.ends_with(".gd") or file.ends_with(".gdc"):
			var loadedInstance = load("res://Objects/Upgrades/Upgrades/" + file)
			var instance = loadedInstance.new()
			print("Upgrade Registered: %s" % instance.getName())
			upgrades.set(instance.getName(), instance)
		
func readUpgradeData(allowDataWrite:bool=false) -> void:
	if not FileAccess.file_exists(upgradeSavePath):
		print("Upgrade Data Saved.")
		if allowDataWrite:
			writeUpgradeData()
		return
		
	var file = FileAccess.open(upgradeSavePath, FileAccess.READ)
	if file:
		var jsonString: String = file.get_as_text()
		var parsed = JSON.parse_string(jsonString)
		var saveData: Dictionary = {}
		if typeof(parsed) == TYPE_DICTIONARY:
			saveData = parsed
			print("Upgrade data loaded: ", saveData)
		else:
			printerr("Error: The Save file is not a dictionary?!")
		file.close()
		
		for key in saveData.keys():
			var data: int = saveData[key]
			var tempUpgrade:UpgradeAbstract = upgrades[key]
			if data < tempUpgrade.getMaxLevel():
				tempUpgrade.setLevel(data)
			else:
				tempUpgrade.setLevel(tempUpgrade.getMaxLevel())
	
func convertUpgradeData() -> Dictionary:
	var result: Dictionary = {}
	for upgrade in upgrades.values():
		result.set(upgrade.getName(), upgrade.getLevel())
	return result
	
func writeUpgradeData() -> void:
	var file = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = convertUpgradeData()
		var jsonString = JSON.stringify(data)
		file.store_string(jsonString)
		file.close()
		print("Upgrade Data Saved.")

func writePlayerData() -> void:
	var file = FileAccess.open(playerSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = player.getSaveData()
		data.set("CookiesScore", cookieScore)
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
	questManager.executeChecks()
	var value:int = 1
	for upgrade in upgrades.values():
		if upgrade.getLevel() <= 0:
			continue
		value = upgrade.onClickAction(value, self)
	changeScore(value)
	
func actionExecution():
	player.emit_signal("updateShopElements")
	questManager.executeChecks()
	var value: int = 0
	var tempPoisenLevel: int = 0
	for upgrade: UpgradeAbstract in upgrades.values():
		if upgrade.getLevel() <= 0:
			continue
		value += upgrade.executeAction(self)
		tempPoisenLevel += upgrade.getPoisenLevel()
	changeScore(value)
	poisonTotal = tempPoisenLevel

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
	
func getUpgrades() -> Dictionary:
	return upgrades
	
func getUpgradeByName(nameUpgrade:String) -> UpgradeAbstract:
	return upgrades.get(nameUpgrade)

func getPoisenLevel() -> int:
	return poisonTotal
	
func getVersion() -> String:
	return VERSION

func getQuestManager() -> QuestManager:
	return questManager

func getSettings() -> Array:
	return settings

func getSettingByName(nameSearch:String) -> Setting:
	for setting in settings:
		if setting.getName() == nameSearch:
			return setting
	return null
