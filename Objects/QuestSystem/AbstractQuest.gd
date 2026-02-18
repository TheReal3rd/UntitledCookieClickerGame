class_name AbstractQuest extends Node

var managerBackRef: QuestManager : set = setManagerBackRef

var questSerialID: int = -1 : get = getID
var questName: String = "AbstractQuestName" : get = getName
var questDescription: String = "AbstractQuestDescription" : get = getDescription
var completed: bool = false : get = isCompleted, set = setCompleted
var questLog: Array = [Pair.new("TemplateName", ["TemplateMessage1", "TemplateMessage2"])] : get = getQuestLog

var quotaAmount: int = 1000 : get = getQuotaAmount
var quotaDeadline: Array = []

func _init(newQuestID:int, newName:String, newDescription:String, newQuestLog:Array, newQuotaAmount:int = -1, newQuotaDeadline: Array = []) -> void:
	questName = newName
	questDescription = newDescription
	questSerialID = newQuestID
	questLog = newQuestLog
	quotaAmount = newQuotaAmount
	quotaDeadline = newQuotaDeadline
	
func executeCheck() -> bool:
	return false

func completionTask() -> void:
	pass
	
func failureTask() -> void:
	pass

#Getters and Setters

func getQuestLog() -> Array:
	return questLog
	
func getQuotaAmount() -> int:
	return quotaAmount
	
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
	
