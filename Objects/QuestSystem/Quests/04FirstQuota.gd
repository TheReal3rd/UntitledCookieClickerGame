extends AbstractQuest

func _init() -> void:
	super._init(4, "First Quota", "Complete your first quota.", [
		Pair.new("MAAN", [
		"Well done on completing your second task.",
		"Now collect 1000 cookies this will be your first quota."
	])], 1000, [ 2, 0, 0, 0, 0, 0 ])

func executeCheck() -> bool:
	return false

func completionTask() -> void:
	pass

func failureTask() -> void:
	pass
