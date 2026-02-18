extends Window

@onready var global = $"/root/Global"

func _on_kill_player_button_pressed() -> void:
	var player = global.getPlayer()
	if player:
		player.emit_signal("playerDeath")
		print("Player Killed Via Debug.")


func _on_close_requested() -> void:
	global.setDebugMenuState(false)
	queue_free()


func _on_reset_player_data_button_pressed() -> void:
	if not global.isGameStarted():
		printerr("You can't reset saved data while not in-game.")
		return
	
	global.resetGame()


func _on_level_debug_room_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/DebugLevels/DebugRoomLevel.tscn")


func _on_spawn_bomb_button_pressed() -> void:
	var player = global.getPlayer()
	if not player:
		printerr("You can't spawn object in when no player object exists.")
		return
	
	var bombLoad = load("res://Objects/WorldObjects/BomberPlane/500KGBomb/500KGBombObject.tscn")
	if not bombLoad:
		printerr("Failed to load the bomb object...")
		return
		
	var bombInstance: StaticBody3D = bombLoad.instantiate()
	if bombInstance:
			get_tree().root.add_child(bombInstance)
			bombInstance.set_global_position(player.get_global_position() + Vector3(0, randf_range(90, 120),0))
			bombInstance.setFalling(true)
			bombInstance.setExplode(true)
			bombInstance.setVelocity(Vector3(randf_range(-0.5, 0.5), -0.1, randf_range(-0.5, 0.5)))
			
		
		
		
		
		
		
