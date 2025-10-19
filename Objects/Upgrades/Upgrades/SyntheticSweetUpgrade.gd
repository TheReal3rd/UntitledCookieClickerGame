extends UpgradeAbstract


func _init() -> void:
	super._init("SyntheticSweetener", "9th formular of an experimental synthetic Sweetener.", 5000)
	setPoisenLevel(5)

@warning_ignore("unused_parameter")
func onClickAction(currentAmount: int, globalInstance: Node) -> int:
	var levelClamped = clamp(level + 1, 2, maxLevel)
	return int(roundf( (currentAmount * levelClamped) * 100))
