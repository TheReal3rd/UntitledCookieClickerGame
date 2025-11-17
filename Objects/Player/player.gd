extends CharacterBody3D

@onready var cameraNode:Camera3D = $Camera3D
@onready var cookieLabel: Label = $Camera3D/Hud/Control/ScoreLabel
@onready var questLabel: Label = $Camera3D/Hud/Control/QuestLabel
@onready var global = get_node("/root/Global")
@onready var shaderRect: ColorRect = $Camera3D/Hud/Control/Shader 
@onready var interactRaycast:RayCast3D = $InteractionRaycast
@onready var spotLight: SpotLight3D = $SpotLight3D
@onready var announcerSound: AudioStreamPlayer3D = $AnnouncerSound
@onready var upgradeExecuterTimer: Timer = $UpgradeExecuteTimer
@onready var hud:CanvasLayer = $Camera3D/Hud
@onready var shopGUI:CanvasLayer = $Camera3D/ShopGUI
@onready var hungerBar: TextureProgressBar = $Camera3D/Hud/Control/HungerBar
@onready var pauseScreenLayer: CanvasLayer = $Camera3D/PauseMenu
@onready var creditScreenLayer: CanvasLayer = $Camera3D/CreditsScreen
@onready var gameStatsLabel: Label = $Camera3D/Hud/Control/GameStatsLabel
@onready var settingScreen: CanvasLayer = $Camera3D/SettingScreen
@onready var exitButton: Button = $Camera3D/RationGUI/Control/ExitButton
@onready var rationMachineGUI: CanvasLayer = $Camera3D/RationGUI
@onready var quotaBar: TextureProgressBar = $Camera3D/Hud/Control/QuotaBar
@onready var interactionLabel: Label = $Camera3D/Hud/Control/InteractionLabel

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const MAX_HUNGER: float = 100.0

var yaw: float = 0.0
var pitch: float = 0.0
var sensitivity: float = 0.1
var mouseTrack: bool = false
var hungerLevel: float = 100.0 : set = setHungerLevel
var gamePaused: bool = false
var quotaDuration: int = -1
var quotaTimeSpan: int = -1

var cookieObject: Node3D
var hoverObject: Node3D

@warning_ignore("unused_signal")
signal openShopScreen(machine:Node)
var shopOpen: bool = false : get = isInShop
var shopUnlocked: bool = false : get = isShopUnlocked, set = setShopLockState
var shopMachineNode : Node

@warning_ignore("unused_signal")
signal updateShopElements
@warning_ignore("unused_signal")
signal updateRationElements

enum FoodItemEnum {
	CRation,
	Cookie
}

func _ready() -> void:
	global.setPlayer(self)
	shaderRect.set_size(get_window().get_size())
	shopGUI.hide()
	hud.show()
	global.readPlayerData(true)
	hungerBar.set_value(hungerLevel)
	hungerBar.set_max(MAX_HUNGER)
	pauseScreenLayer.hide()
	creditScreenLayer.hide()
	gameStatsLabel.hide()
	settingScreen.hide()
	rationMachineGUI.hide()
	interactionLabel.hide()
	updateSettingsStats()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if shopOpen:
				closeShop()
			else:
				pauseGame()

func _unhandled_input(event: InputEvent) -> void:
	if shopOpen:
		return
	
	if event is InputEventMouseMotion:
		var mouseEvent: InputEventMouseMotion = event
		if not mouseTrack:
			return
		yaw -= mouseEvent.relative.x * sensitivity
		pitch -= mouseEvent.relative.y * sensitivity
		pitch = clamp(pitch, -89, 89)
		rotation_degrees.y = yaw
		cameraNode.rotation_degrees.x = pitch
		interactRaycast.set_rotation(cameraNode.get_rotation())
		spotLight.set_rotation(cameraNode.get_rotation())
	
	if event is InputEventMouseButton and event.is_pressed():
		var mouseEvent: InputEventMouseButton = event
		if Input.get_mouse_mode() != 2:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouseTrack = true
		
		var mouseIndex:int = mouseEvent.get_button_index()
		if mouseIndex == 1:#Left
			if not interactRaycast.is_colliding():
				return
			
			if interactRaycast.get_collider() is StaticBody3D:
				var interactionObject: StaticBody3D = interactRaycast.get_collider()
				if interactionObject.is_in_group("CookieObject"):
					global.cookieClick()
			
		elif mouseIndex == 2:#Right
			pass
			
	if event is InputEventKey and event.is_pressed():
		var inputEvent: InputEventKey = event
		if inputEvent.get_keycode() == 69 and interactionLabel.is_visible():
			if hoverObject:
				hoverObject.emit_signal("openGUI")
				emit_signal("openShopScreen" ,hoverObject)
		
func pauseGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouseTrack = false
	gamePaused = true
	pauseScreenLayer.show()
	shopGUI.hide()
	hud.hide()
	get_tree().paused = true
		
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	interactRaycast.force_raycast_update()
	if interactRaycast.is_colliding() and interactRaycast.get_collider() is AbstractInteractionObject:
		var interactionObject: AbstractInteractionObject = interactRaycast.get_collider()
		if interactionObject.is_in_group("InteractableObject") and interactionObject.isUnlocked() and get_global_position().distance_to(interactionObject.get_global_position()) <= 2.3 :
			hoverObject = interactionObject
			interactionLabel.show()
		else:
			interactionLabel.hide()
			hoverObject = null
	else:
		interactionLabel.hide()
		hoverObject = null
	
	if hud.is_visible():
		if gameStatsLabel.is_visible():
			gameStatsLabel.set_text("FPS: %d" % [ Engine.get_frames_per_second() ])
		if cookieLabel.is_visible():
			cookieLabel.set_text("Cookies: %d" % global.getScore())
	
	if not get_window().has_focus() and not shopOpen:
		pauseGame()
		
	if not cookieObject:
		cookieObject = global.getCookie()
	else:
		if cameraNode.is_position_behind(cookieObject.get_global_position()):
			cookieLabel.show()
		elif cameraNode.is_position_in_frustum(cookieObject.get_global_position()):
			cookieLabel.hide()
	
	var autoClickSpeed: UpgradeAbstract = global.getUpgradeByName("AutoClickerSpeed")
	if autoClickSpeed and autoClickSpeed.getLevel() >= 1:
		var clickTime:float = 10 - (autoClickSpeed.getLevel() * 0.5)
		if upgradeExecuterTimer.get_wait_time() != clickTime:
			upgradeExecuterTimer.set_wait_time(clickTime)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("leftward", "rightward", "foreward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_open_shop_screen(machine:Node) -> void:
	if Input.get_mouse_mode() == 2:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	mouseTrack = false
	shopOpen = true
	shopMachineNode = machine
	hud.hide()
	if machine.is_in_group("RationMachineObject"):
		rationMachineGUI.show()
		emit_signal("updateRationElements")
	else:
		shopGUI.show()
		emit_signal("updateShopElements")


func isInShop() -> bool:
	return shopOpen
	
func closeShop() -> void:
	hud.show()
	shopGUI.hide()
	rationMachineGUI.hide()
	shopOpen = false
	mouseTrack = true
	if Input.get_mouse_mode() == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	shopMachineNode.emit_signal("closeGUI")

func _on_exit_button_pressed() -> void:
	closeShop()

func _on_upgrade_execute_timer_timeout() -> void:
	global.actionExecution()

func _on_auto_save_timer_timeout() -> void:
	global.writeUpgradeData()
	global.writePlayerData()

func _on_tree_exiting() -> void:
	global.writeUpgradeData()
	global.writePlayerData()
	
func getSaveData() -> Dictionary:
	var location: Vector3 = get_global_position()
	return {
		"PosX" : location.x,
		"PosY" : location.y,
		"PosZ" : location.z,
		"Yaw" : yaw,
		"Pitch" : pitch,
		"ShopLockState" : shopUnlocked
	}
	
func setSaveData(data:Dictionary) -> void:
	var location: Vector3 = Vector3.ZERO
	if data.has("PosX"):
		location.x = data.get("PosX")
	if data.has("PosY"):
		location.y = data.get("PosY")
	if data.has("PosZ"):
		location.z = data.get("PosZ")
		
	if data.has("Yaw"):
		yaw = data.get("Yaw")
	if data.has("Pitch"):
		pitch = data.get("Pitch")
		
	if data.has("ShopLockState"):
		shopUnlocked = data.get("ShopLockState")
		
	if location.y <= 0:
		location.y = 4
	
	set_global_position(location)
	rotation_degrees.y = yaw
	cameraNode.rotation_degrees.x = pitch
	
func playSound(path:String, play:bool=true):
	var stream = AudioStreamMP3.load_from_file(path)
	announcerSound.set_stream(stream)
	announcerSound.set_playing(play)
	
func _on_ready() -> void:
	global.playerIsReady()
	
func setQuestLabelText(questDesciption:String):
	questLabel.set_text(questDesciption)

func isShopUnlocked() -> bool:
	return shopUnlocked
	
func setShopLockState(newState:bool) -> void:
	shopUnlocked = newState

func _on_hunger_timer_timeout() -> void:
	changeHungerLevel(-0.5)
	if hungerLevel <= -10:
		print("Player Death needs implementing...")
		
func resume() -> void:
	gamePaused = false
	get_tree().paused = false
	pauseScreenLayer.hide()
	hud.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouseTrack = true
	
func showCredits() -> void:
	pauseScreenLayer.hide()
	creditScreenLayer.show()
	
func backToPauseScreen() -> void:
	pauseScreenLayer.show()
	creditScreenLayer.hide()
	settingScreen.hide()
	
func showSettings() -> void:
	pauseScreenLayer.hide()
	settingScreen.show()
	
func updateSettingsStats() -> void:
	var fpsSetting: Setting = global.getSettingByName("ShowFPS")
	if fpsSetting.getValue():
		gameStatsLabel.show()
	else:
		gameStatsLabel.hide()
	
func calcFoodPrice(foodItem:FoodItemEnum) -> int:
	var price: int = 0
	var multi:int = 0
	for upgrade:UpgradeAbstract in global.getUpgrades().values():
		if upgrade.getLevel() <= 0:
			continue
		multi += upgrade.getLevel() 
	match(foodItem):
		FoodItemEnum.CRation:
			price = roundi(100 * multi)
		FoodItemEnum.Cookie:
			price = roundi(10 * multi)
	return price
	
func buyFood(foodItem:FoodItemEnum) -> void:
	var price = calcFoodPrice(foodItem)
	
	if global.getScore() >= price:
		global.changeScore(-price)
		match (foodItem):
			FoodItemEnum.CRation:
				changeHungerLevel(35)
			FoodItemEnum.Cookie:
				changeHungerLevel(10)

func setHungerLevel(newLevel:float) -> void:
	hungerLevel = clamp(newLevel, 0.0, 100.0)
	hungerBar.set_value(hungerLevel)
	
func changeHungerLevel(amount:float) -> void:
	setHungerLevel(hungerLevel + amount)

func _on_buy_cookie_button_pressed() -> void:
	buyFood(FoodItemEnum.Cookie)

func _on_buy_ration_button_pressed() -> void:
	buyFood(FoodItemEnum.CRation)
	
func updateQuotaStats() -> void:
	var questManager = global.getQuestManager()
	if questManager:
		var quest = questManager.getCurrentQuest()
		if quest:
			quotaDuration = quest.getQuotaDuration()
			quotaTimeSpan = 0
			return
		
	if quotaDuration == -1 or quotaTimeSpan == -1:
		quotaBar.hide()
