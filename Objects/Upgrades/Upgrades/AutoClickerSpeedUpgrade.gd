extends UpgradeAbstract

func _init() -> void:
	super._init("AutoClickerSpeed", "Increase Auto Clicker click rate.", 500, 9)

func getPrice() -> int:
	if level <= 0:
		return price
	return int(price * (clamp(level, 2, maxLevel) * 2))
