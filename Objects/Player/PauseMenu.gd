extends Control

@onready var global = get_node("/root/Global")
@onready var versionLabel: Label = $VersionLabel
@onready var exitButton: Button = $ExitButton

func _ready() -> void:
	versionLabel.set_text("Version: %s" % global.getVersion())
	if OS.get_name() == "Web":
		exitButton.hide()

func _on_resume_button_pressed() -> void:
	global.getPlayer().resume()

func _on_credits_button_pressed() -> void:
	global.getPlayer().showCredits()

func _on_settings_button_pressed() -> void:
	global.getPlayer().showSettings()

func _on_exit_button_pressed() -> void:
	global.writePlayerData()
	global.writeUpgradeData()
	global.getQuestManager().writeQuestData()
	get_tree().free()
