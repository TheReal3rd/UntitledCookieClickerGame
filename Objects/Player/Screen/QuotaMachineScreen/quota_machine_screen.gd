extends Control

@onready var global: Node = $"/root/Global"
@onready var quotaLabel: Label = $QuotaLabel
@onready var deadlineLabel: Label = $DeadlineLabel
@onready var payedStatusLabel: Label = $PayedLabel
@onready var todayDateLabel: Label = $TodayDateLabel

const quotaString: String = "Quota Target: %s"
const deadlineString: String = "Deadline: %s"
const payedStatusString: String = "Payed: %s" 
const todayDateString: String = "Date: %s" 

func _ready() -> void:
	updateScreen()

func updateScreen() -> void:
	var questMan: QuestManager = global.getQuestManager()
	var timeDateManager: TimeDateManger = global.getTimeDateManager()
	if not questMan:
		quotaLabel.set_text(quotaString % "N/A")
		deadlineLabel.set_text(deadlineString % "N/A")
		payedStatusLabel.set_text(payedStatusString % "N/A")
		todayDateLabel.set_text(todayDateString % "N/A")
		return

	quotaLabel.set_text(quotaString % questMan.getQuotaCost())
	deadlineLabel.set_text(deadlineString % timeDateManager.getDateTimeFormatted(questMan.getQuotaDeadline()))
	var payedState: String = "NEGATIVE"
	var quotaPaidState = questMan.isQuotaPaid()
	if quotaPaidState == 1:
		payedState = "POSITIVE"
	elif quotaPaidState == -1:
		payedState = "FAILED"
	payedStatusLabel.set_text(payedStatusString % payedState)
	todayDateLabel.set_text(todayDateString % timeDateManager.getDateTimeFormatted())

func _on_pay_button_pressed() -> void:
	var questMan: QuestManager = global.getQuestManager()
	if questMan:
		if questMan.isQuotaPaid() == 0:
			questMan.payQuota()
			updateScreen()
	else:
		printerr("Paying Quota | Quest Manager is not initilized. Can't complete this action.")


func _on_exit_button_pressed() -> void:
	var player: playerObject = global.getPlayer()
	if player:
		player.emit_signal("exitGUIButton")
	else:
		get_tree().root.queue_free()

func _on_timer_timeout() -> void:
	updateScreen()
