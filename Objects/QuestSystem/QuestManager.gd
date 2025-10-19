class_name QuestManager extends Resource

const questSavePath: String = "user://questData.json"
var global: Node : get = getGlobalRef

var currentQuestID:int = 1
var currentQuestCach: AbstractQuest
var questList: Dictionary = {}

func _init(globalInstance:Node) -> void:
	global = globalInstance
	registerQuests()
	readQuestData(true)
	
func registerQuests() -> void:
	var files: Array[String] = global.listFiles("res://Objects/QuestSystem/Quests/")
	for file in files:
		if file.ends_with(".gd") or file.ends_with(".gdc"):	
			var loadedInstance = load("res://Objects/QuestSystem/Quests/" + file)
			var instance = loadedInstance.new()
			instance.setManagerBackRef(self)
			print("Quest Registered: %s" % instance.getName())
			questList.set(instance.getID(), instance)
			
func executeChecks() -> void:
	if currentQuestID == -1:#If we reach ID -1 means there is no more quest after so we have completed all quests.
		global.getPlayer().setQuestLabelText("No Tasks.")
		return
	
	if currentQuestCach:
		if currentQuestCach.executeCheck():
			currentQuestCach.completionTask()
			currentQuestCach.setCompleted(true)
			currentQuestID += 1
			setCurrentQuestCach()
	else:
		setCurrentQuestCach()
		
func setCurrentQuestCach() -> void:
	if currentQuestID > questList.size():
		currentQuestID = -1
		return
		
	currentQuestCach = questList[currentQuestID]
	if currentQuestCach.isCompleted():
		currentQuestID += 1
		setCurrentQuestCach()
	
	if not currentQuestCach.hasAnnoucementPlayed():
		if currentQuestCach.getSoundPath() == "":
			return
		var player:Node = global.getPlayer()
		if player:
			player.playSound(currentQuestCach.getSoundPath())
			player.setQuestLabelText(currentQuestCach.getDescription())
			currentQuestCach.setAnnoucementPlayed(true)
	

func playerIsReady() -> void:
	setCurrentQuestCach()

func readQuestData(allowDataWrite:bool=false) -> void:
	if not FileAccess.file_exists(questSavePath):
		print("Quest Data Saved.")
		if allowDataWrite:
			writeQuestData()
		return
		
	var file = FileAccess.open(questSavePath, FileAccess.READ)
	if file:
		var jsonString: String = file.get_as_text()
		var parsed = JSON.parse_string(jsonString)
		var saveData: Dictionary = {}
		if typeof(parsed) == TYPE_DICTIONARY:
			saveData = parsed
			print("Quest data loaded: ", saveData)
		else:
			printerr("Error: The Save file is not a dictionary?!")
			writeQuestData()
		file.close()
		
		for quest in questList.values():
			if saveData.has(quest.getName()):
				quest.setData(saveData.get(quest.getName()))
	
func writeQuestData() -> void:
	var file = FileAccess.open(questSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = buildSaveData()
		var jsonString = JSON.stringify(data)
		file.store_string(jsonString)
		file.close()
		print("Quest Data Saved.")
	
func buildSaveData() -> Dictionary:
	var saveData: Dictionary = {}
	for quest in questList.values():
		saveData.set(quest.getName(), quest.getSaveData())
	return saveData
	
func getGlobalRef() -> Node:
	return global
