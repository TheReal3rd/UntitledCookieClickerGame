extends AbstractQuest

func _init() -> void:
	super._init(1, "Introduction", "Make a Start. Get 100 cookies.", "", 1000)

func executeCheck() -> bool:
	if managerBackRef.getGlobalRef().getScore() >= 100:
		return true
	else:
		return false

func completionTask() -> void:
	var player: Node = managerBackRef.getGlobalRef().getPlayer()
	if player:
		player.setShopLockState(true)
