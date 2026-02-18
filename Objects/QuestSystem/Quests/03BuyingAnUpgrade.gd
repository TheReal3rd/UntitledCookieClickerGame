extends AbstractQuest

func _init() -> void:
	super._init(3, "Getting an Upgrade", "Purchase an upgrade.", [
	Pair.new("MAAN", [
		"Well done on completing your second task."
	])], -1)

func executeCheck() -> bool:
	var upgrade: UpgradeAbstract = managerBackRef.getGlobalRef().getUpgradeByName("Clicker")
	if upgrade:
		return upgrade.getLevel() >= 1
	else:
		return false

func completionTask() -> void:
	pass
