extends Control

@onready var global: Node = get_node("/root/Global")



func _on_back_button_pressed() -> void:
	global.getPlayer().backToPauseScreen()
