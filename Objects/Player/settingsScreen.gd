extends Control

@onready var settingScrollArea = $VBoxContainer
@onready var crtShader = $CRTShaderPauseMenus
@onready var settingElement = preload("res://Objects/Settings/SettingElement.tscn")
@onready var global = get_node("/root/Global")

func _ready() -> void:
	if global.isGameStarted():
		crtShader.hide()
		crtShader.queue_free()
	else:
		crtShader.show()

	for setting: Setting in global.getSettings():
		var tempElement: Node = settingElement.instantiate()
		tempElement.setSetting(setting)
		settingScrollArea.add_child(tempElement)
		tempElement.updateElement()

func _on_back_button_pressed() -> void:
	if global.isGameStarted():
		global.getPlayer().backToPauseScreen()
	else:
		get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")
