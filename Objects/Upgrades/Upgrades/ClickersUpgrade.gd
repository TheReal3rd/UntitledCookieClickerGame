extends UpgradeAbstract


func _init() -> void:
	super._init("Clicker", "Multiplies your clicks by the level.", 100)


@warning_ignore("unused_parameter")
func onClickAction(currentAmount: int, globalInstance: Node) -> int:
	var levelClamped = clamp(level + 1, 2, maxLevel)
	return int(roundf(currentAmount * levelClamped))
