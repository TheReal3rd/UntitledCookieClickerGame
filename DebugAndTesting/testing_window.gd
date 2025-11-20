extends Window

@onready var global = $"/root/Global"

func _on_kill_player_button_pressed() -> void:
	var player = global.getPlayer()
	if player:
		player.emit_signal("playerDeath")
		print("Player Killed Via Debug.")


func _on_close_requested() -> void:
	queue_free()
