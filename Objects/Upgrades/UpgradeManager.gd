class_name UpgradeManager extends Resource

var global: Node
var globalUtils: Node

const upgradeSavePath: String = "user://upgradeData.json"
var upgrades: Dictionary = {} : get = getUpgrades

func _init(globalInst: Node, globalUtilsInst: Node) -> void:
	global = globalInst
	globalUtils = globalUtilsInst
	
	registerUpgrades()
	readUpgradeData(true)

func registerUpgrades() -> void:
	var files: Array[String] = globalUtils.listFiles("res://Objects/Upgrades/Upgrades/")
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
	if not global.isGameStarted():
		return
	
	var file = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = convertUpgradeData()
		var jsonString = JSON.stringify(data)
		file.store_string(jsonString)
		file.close()
		print("Upgrade Data Saved.")
		
func resetUpgrades() -> void:
	for upgrade: UpgradeAbstract in upgrades.values():
		upgrade.resetData()
		
		
func getUpgrades() -> Dictionary:
	return upgrades
	
func getUpgradeByName(nameUpgrade:String) -> UpgradeAbstract:
	return upgrades.get(nameUpgrade)
		
