extends AbstractQuest

func _init() -> void:
	super._init(1, "Introduction", "Talk to MAAN.", 
	Pair.new("MAAN", 
	[
		"Welcome Unit 2864A-7.",
		"You have been aquired by The Central Administration to work",
		"for the Ministry of The Ministry of Agriculture and Nutrition",
		"or MAAN for short. You must meet my demands or you will be",
		"recycled to more useful product to help with the war effort.",
		"You have now successfully completed your first objective."
	]), 
	-1)

func executeCheck() -> bool:
	var player: Node = managerBackRef.getGlobalRef().getPlayer()
	if player:
		return player.isFirstOpenedMan()
	else:
		return false 

func completionTask() -> void:
	pass
