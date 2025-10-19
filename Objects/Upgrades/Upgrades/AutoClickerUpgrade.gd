extends UpgradeAbstract

func _init() -> void:
	super._init("AutoClicker", "Automatically generate cookies. Helped by other party workers.", 250)

@warning_ignore("unused_parameter")
func executeAction(globalInstance: Node) -> int:
	var levelClamped = clamp(level + 1, 2, maxLevel)
	return int(roundf(levelClamped))
