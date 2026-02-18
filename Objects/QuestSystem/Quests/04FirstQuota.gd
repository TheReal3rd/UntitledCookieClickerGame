extends AbstractQuest

func _init() -> void:
	super._init(3, "First Quota", "Complete your first quota.", [
		Pair.new("MAAN", [
		"Well done on completing your second task.",
		"Now collect 1000 cookies this will be your first quota."
	])], 1000)

func executeCheck() -> bool:
	return false

func completionTask() -> void:
	pass
