extends AbstractQuest

func _init() -> void:
	super._init(2, "Getting started", "Make a Start. Get 100 cookies.", 
	Pair.new("MAAN", 
	[
		"Now collect 100 cookies.",
		"Lets no stand there get started."
	]), 
	-1)

func executeCheck() -> bool:
	var upgrade: UpgradeAbstract = managerBackRef.getGlobalRef().getUpgradeByName("Clicker")
	if upgrade:
		return upgrade.getLevel() >= 1
	else:
		return false

func completionTask() -> void:
	pass
