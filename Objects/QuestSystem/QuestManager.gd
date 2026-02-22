class_name QuestManager extends Resource

const questSavePath: String = "user://questData.json"
var global: Node : get = getGlobalRef
var globalUtils: Node : get = getGlobalUtilsRef

var currentQuestID:int = 1
var currentQuestCach: AbstractQuest : get = getCurrentQuest
var questList: Dictionary = {}

var quotaDateTime: Array = [] : get = getQuotaDeadline
var quotaAmount: int = -1 : get = getQuotaCost
var quotaPaid: bool = false : get = isQuotaPaid

func _init(globalInstance:Node, globalUtilsInstance: Node) -> void:
	global = globalInstance
	globalUtils = globalUtilsInstance
	registerQuests()
	readQuestData(true)
	
func registerQuests() -> void:
	var files: Array[String] = globalUtils.listFiles("res://Objects/QuestSystem/Quests/")
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
	if currentQuestID > questList.size() or currentQuestID == -1:
		currentQuestID = -1
		return
		
	var player: playerObject = global.getPlayer()
	currentQuestCach = questList[currentQuestID]
	if currentQuestCach.isCompleted():
		currentQuestID += 1
		setCurrentQuestCach()
		quotaDateTime = []
		if player:
			player.updateQuotaStats()
	
	if quotaDateTime.size() <= 0 and currentQuestCach:
		var timeManager: TimeDateManger = global.getTimeDateManager()
		var now: Array = timeManager.getTimeDate()
		var offset = currentQuestCach.getQuotaOffset()
		if not offset.size() <= 0:
			quotaDateTime = timeManager.offsetTimeAndDate(now, offset)
			quotaAmount = currentQuestCach.getQuotaAmount()
			
	
	if player:
		player.setQuestLabelText(currentQuestCach.getDescription())
	
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
		
		if saveData.has("QuotaDateTime"):
			quotaDateTime = saveData.get("QuotaDateTime")
			
		if saveData.has("QuotaAmount"):
			quotaAmount = saveData.get("QuotaAmount")
			
		if saveData.has("QuotaPaid"):
			quotaPaid = saveData.get("QuotaPaid")
		
		for quest in questList.values():
			if saveData.has(quest.getName()):
				quest.setData(saveData.get(quest.getName()))
	
func writeQuestData() -> void:
	var file = FileAccess.open(questSavePath, FileAccess.WRITE)
	if file:
		var data: Dictionary = buildSaveData()
		if not quotaDateTime.size() <= 0:
			data.set("QuotaDateTime" , quotaDateTime)
		if quotaAmount != -1:
			data.set("QuotaAmount", quotaAmount)
		data.set("QuotaPaid", quotaPaid)
		
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
	
func getGlobalUtilsRef() -> Node:
	return globalUtils
	
func getCurrentQuest() -> AbstractQuest:
	return currentQuestCach
	
func getQuotaDeadline() -> Array:
	return quotaDateTime
	
func getQuotaCost() -> int:
	return quotaAmount
	
func isQuotaPaid() -> bool:
	return quotaPaid
	
func payQuota() -> bool:
	if not quotaPaid:
		var score = global.getScore()
		if score >= quotaAmount:
			global.changeScore(-quotaAmount)
			quotaPaid = true
			return true
	return false
	
func resetQuestData() -> void:
	for quest: AbstractQuest in questList.values():
		quest.resetData()
	currentQuestID = 1
	quotaAmount = -1
	quotaDateTime = []
	quotaPaid = false
	setCurrentQuestCach()
	writeQuestData()
