class_name AbstractQuest extends Node

var managerBackRef: QuestManager : set = setManagerBackRef

var questSerialID: int = -1 : get = getID
var questName: String = "AbstractQuestName" : get = getName
var questDescription: String = "AbstractQuestDescription" : get = getDescription
var completed: bool = false : get = isCompleted, set = setCompleted
var questLog: String = "AbstractQuestLog" : get = getQuestLog

var quotaDuration: int = 1000 : get = getQuotaDuration

func _init(newQuestID:int, newName:String, newDescription:String, newQuestLog:String, newQuotaDuration:int) -> void:
	questName = newName
	questDescription = newDescription
	questSerialID = newQuestID
	questLog = newQuestLog
	quotaDuration = newQuotaDuration
	
func executeCheck() -> bool:
	return false

func completionTask() -> void:
	pass

#Getters and Setters

func getQuestLog() -> String:
	return questLog
	
func getQuotaDuration() -> int:
	return quotaDuration
	
func getID() -> int:
	return questSerialID
	
func getName() -> String:
	return questName
	
func getDescription() -> String:
	return questDescription
	
func setManagerBackRef(newManager) -> void:
	managerBackRef = newManager
	
func isCompleted() -> bool:
	return completed
	
func setCompleted(newState) -> void:
	completed = newState
	
func getSaveData() -> Dictionary:
	return {
		"completed" : completed,
	}
	
func setData(saveData:Dictionary) -> void:
	if saveData.has("completed"):
		completed = saveData.get("completed")
		
func resetData() -> void:
	completed = false
	
