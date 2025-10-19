extends AbstractQuest

func _init() -> void:
	super._init(2, "Getting an Upgrade", "Purchase an upgrade.", "res://Assets/Sound/introAudio.mp3")

func executeCheck() -> bool:
	var upgrade: UpgradeAbstract = managerBackRef.getGlobalRef().getUpgradeByName("Clicker")
	if upgrade:
		return upgrade.getLevel() >= 1
	else:
		return false

func completionTask() -> void:
	pass
