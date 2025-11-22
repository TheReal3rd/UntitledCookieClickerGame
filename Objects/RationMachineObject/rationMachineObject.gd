extends AbstractInteractionObject

func _on_close_gui() -> void:
	setActive(false)

func _on_open_gui() -> void:
	setActive(true)
	
