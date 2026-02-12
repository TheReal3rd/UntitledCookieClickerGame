extends Control

@onready var textEntr = preload("res://Objects/ScreenManObject/TextEntryElements/TextEntryElement.tscn")

@onready var entryContainer: VBoxContainer = $ScrollContainer/MessageEntries
@onready var global: Node = $"/root/Global"

var questMan: QuestManager
var questData: AbstractQuest

func _ready() -> void:
	pass
	
func updateMessageLog():
	questMan = global.getQuestManager()
	questData = questMan.getCurrentQuest()
	if not questData:
		var entry = textEntr.instantiate()
		entry.setName("SYSTEM")
		entry.setMessage("No instructions provided.")
		entryContainer.add_child(entry)
	else:
		var questLog: Pair = questData.getQuestLog()
		var messages: Array = questLog.getSecond()
		var lastName: String = ""
		for msg in messages:
			var entry = textEntr.instantiate()
			var msgName = questLog.getFirst()
			if lastName != msgName:
				entry.setName(msgName)
				lastName = msgName
			entry.setMessage(msg)
			entryContainer.add_child(entry)
			
	var player:Node = global.getPlayer()
	if player:
		player.setFirstOpenedMan(true)
	

func _process(delta: float) -> void:
	pass
