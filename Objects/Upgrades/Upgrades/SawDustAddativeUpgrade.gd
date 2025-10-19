extends UpgradeAbstract


func _init() -> void:
	super._init("SawDustAddative", "Adding saw dust to the cookie formula producing more cookies. However is it healthy?", 150)
	setPoisenLevel(1)

@warning_ignore("unused_parameter")
func onClickAction(currentAmount: int, globalInstance: Node) -> int:
	var levelClamped = clamp(level + 1, 2, maxLevel)
	return int(roundf(currentAmount * levelClamped))
