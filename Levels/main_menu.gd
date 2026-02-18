extends Control

@onready var global: Node = $"/root/Global"
@onready var exitButton: Button = $ExitButton

func _ready() -> void:
	if OS.get_name() == "Web":
		exitButton.hide()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level1.tscn")
	global.startGame()

func _on_setting_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/SettingsMenu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit(0)
