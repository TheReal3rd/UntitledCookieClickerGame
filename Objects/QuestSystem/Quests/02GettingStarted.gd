extends AbstractQuest

func _init() -> void:
	super._init(2, "Getting started", "Make a Start. Get 100 cookies.", [
	Pair.new("MAAN", 
	[
		"Now collect 100 cookies.",
		"Lets no stand here get started."
	])], -1)

func executeCheck() -> bool:
	return managerBackRef.getGlobalRef().getScore() >= 100

func completionTask() -> void:
	var flagTracker: FlagTracker = managerBackRef.getGlobalRef().getFlagTracker()
	if flagTracker:
		flagTracker.pushFlag("UNLOCKED_SHOP_MACHINE", true)
