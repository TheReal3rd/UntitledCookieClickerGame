extends Control

@onready var settingScrollArea = $VBoxContainer
@onready var crtShader = $CRTShaderPauseMenus
@onready var videoStream = $VideoStreamPlayer
@onready var settingElement = preload("res://Objects/Settings/SettingElement.tscn")
@onready var global = get_node("/root/Global")

func _ready() -> void:
	if global.isGameStarted():
		crtShader.hide()
		crtShader.queue_free()
		videoStream.hide()
		videoStream.queue_free()
	else:
		crtShader.show()

	var isWeb = OS.get_name() == "Web"

	for setting: Setting in global.getSettings():
		if isWeb and setting.isWebHidden():
			continue
			
		var tempElement: Node = settingElement.instantiate()
		tempElement.setSetting(setting)
		settingScrollArea.add_child(tempElement)
		tempElement.updateElement()

func _on_back_button_pressed() -> void:
	if global.isGameStarted():
		global.getPlayer().backToPauseScreen()
	else:
		get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")
