extends VBoxContainer

@onready var nameLabel:Label = $HSplitContainer/NameLabel
@onready var toggleCheckBox:CheckButton = $HSplitContainer/ToggleCheckButton
@onready var global = get_node("/root/Global")

var settingObject:Setting : set = setSetting, get = getSetting

func _ready() -> void:
	toggleCheckBox.hide()
	
func updateElement() -> void:
	if settingObject:
		nameLabel.set_text(settingObject.getName())
		if settingObject.getValue() is bool:
			toggleCheckBox.show()
			toggleCheckBox.set_pressed(settingObject.getValue())
	
func setSetting(newSetting:Setting) -> void:
	settingObject = newSetting
	
func getSetting() -> Setting:
	return settingObject

func _on_toggle_check_button_pressed() -> void:
	settingObject.setValue(toggleCheckBox.is_pressed())
	global.writeSettingData()
	if global.isGameStarted():
		global.getPlayer().updateSettingsStats()
