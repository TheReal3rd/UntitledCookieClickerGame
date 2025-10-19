extends Control

@onready var settingScrollArea = $VBoxContainer
@onready var settingElement = preload("res://Objects/Settings/SettingElement.tscn")
@onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for setting: Setting in global.getSettings():
		var tempElement: Node = settingElement.instantiate()
		tempElement.setSetting(setting)
		settingScrollArea.add_child(tempElement)
		tempElement.updateElement()


func _on_back_button_pressed() -> void:
	global.getPlayer().backToPauseScreen()
