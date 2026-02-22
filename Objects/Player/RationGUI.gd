extends Control

@onready var global = get_node("/root/Global")
@onready var cookieBuyButton: Button = $HBoxContainer/VBoxContainer/BuyCookieButton
@onready var rationBuyButton: Button = $HBoxContainer/VBoxContainer2/BuyRationButton
@onready var fadeRect: ColorRect = $FadeRect

func _ready() -> void:
	fadeRect.modulate.a = 1
	fadeRect.show()

func _process(delta: float) -> void:
	if is_visible():
		if fadeRect.modulate.a != 0.0:
			fadeRect.modulate.a = lerpf(fadeRect.modulate.a, 0.0, 0.25 * delta)
			if fadeRect.modulate.a <= 0.1:
				fadeRect.hide()

func _on_player_update_ration_elements() -> void:
	var playerNode: Node = global.getPlayer()
	if playerNode:
		cookieBuyButton.set_text("Buy (%d)" % playerNode.calcFoodPrice(playerNode.FoodItemEnum.Cookie))
		rationBuyButton.set_text("Buy (%d)" % playerNode.calcFoodPrice(playerNode.FoodItemEnum.CRation))
