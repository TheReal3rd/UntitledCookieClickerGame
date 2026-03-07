extends AbstractQuest

func _init() -> void:
	super._init(4, "First Quota", "Complete your first quota.", [
		Pair.new("MAAN", [
		"Well done on completing your second task.",
		"Now collect 1000 cookies this will be your first quota."
	])], 1000, [ 2, 0, 0, 0, 0, 0 ])

func executeCheck() -> bool:
	var global: Node = managerBackRef.getGlobalRef()
	if not global:
		return false
		
	var timeDateMan: TimeDateManger = global.getTimeDateManager()
	if timeDateMan:
		var passedQuota: bool = timeDateMan.hasPassedTimeAndDate(managerBackRef.getQuotaDeadline())
		return passedQuota and managerBackRef.isQuotaPaid() == 1
	return false

func completionTask() -> void:
	pass

func failureTask() -> void:
	pass
