class_name AbstractQuest extends Node

var managerBackRef: QuestManager : set = setManagerBackRef

var questSerialID: int = -1 : get = getID
var questName: String = "AbstractQuestName" : get = getName
var questDescription: String = "AbstractQuestDescription" : get = getDescription
var annoucementPlayed: bool = false : get = hasAnnoucementPlayed, set = setAnnoucementPlayed
var annoucementSoundPath: String = "" : get = getSoundPath
var completed: bool = false : get = isCompleted, set = setCompleted

func _init(newQuestID:int, newName:String, newDescription:String, newSoundPath: String) -> void:
	questName = newName
	questDescription = newDescription
	annoucementSoundPath = newSoundPath
	questSerialID = newQuestID
	
func executeCheck() -> bool:
	return false

func completionTask() -> void:
	pass

#Getters and Setters

func getID() -> int:
	return questSerialID
	
func getName() -> String:
	return questName
	
func getDescription() -> String:
	return questDescription
	
func hasAnnoucementPlayed() -> bool:
	return annoucementPlayed
	
func setAnnoucementPlayed(newState) -> void:
	annoucementPlayed = newState
	
func getSoundPath() -> String:
	return annoucementSoundPath
	
func setManagerBackRef(newManager) -> void:
	managerBackRef = newManager
	
func isCompleted() -> bool:
	return completed
	
func setCompleted(newState) -> void:
	completed = newState
	
func getSaveData() -> Dictionary:
	return {
		"annoucementPlayed" : annoucementPlayed,
		"completed" : completed,
	}
	
func setData(saveData:Dictionary) -> void:
	if saveData.has("annoucementPlayed"):
		annoucementPlayed = saveData.get("annoucementPlayed")
	if saveData.has("completed"):
		completed = saveData.get("completed")
	
