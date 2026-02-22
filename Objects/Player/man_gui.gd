extends Control

@onready var textEntr = preload("res://Objects/WorldObjects/ScreenManObject/TextEntryElements/TextEntryElement.tscn")

@onready var entryContainer: VBoxContainer = $ScrollContainer/MessageEntries
@onready var global: Node = $"/root/Global"

var questMan: QuestManager
var questData: AbstractQuest
	
func updateMessageLog():
	questMan = global.getQuestManager()
	if not questMan:
		return
	
	questData = questMan.getCurrentQuest()
	if not questData:
		var entry = textEntr.instantiate()
		entry.setName("SYSTEM")
		entry.setMessage("No instructions provided.")
		entryContainer.add_child(entry)
	else:
		var questLog: Array = questData.getQuestLog()
		for mLog: Pair in questLog:
			var messages: Array = mLog.getSecond()
			var lastName: String = ""
			for msg in messages:
				var entry = textEntr.instantiate()
				var msgName = mLog.getFirst()
				if lastName != msgName:
					entry.setName(msgName)
					lastName = msgName
				entry.setMessage(msg)
				entryContainer.add_child(entry)
			
	var flagTracker: FlagTracker = global.getFlagTracker()
	if flagTracker:
		flagTracker.fetchFlag("FIRST_INTERACT_MANN_MACHINE")
