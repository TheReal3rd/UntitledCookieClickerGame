extends Control

@onready var itemContainer = $VBoxContainer
@onready var global = get_node("/root/Global")
@onready var fadeRect: ColorRect = $FadeRect

@onready var shopItemElementPath = preload("res://Objects/ShopMachineObject/ShopItem/ShopItem.tscn")

func _ready() -> void:
	fadeRect.modulate.a = 1
	fadeRect.show()
	var upgrades: Dictionary = global.getUpgrades()
	var upgradeListSorted = upgrades.values().duplicate(true)
	upgradeListSorted.sort_custom(func(a:UpgradeAbstract, b:UpgradeAbstract): return a.getPrice() < b.getPrice())
	for upgrade in upgradeListSorted:
		var tempItem: Node = shopItemElementPath.instantiate()
		tempItem.setUpgrade(upgrade)
		itemContainer.add_child(tempItem)

func _process(delta: float) -> void:
	if fadeRect.modulate.a != 0.0:
		fadeRect.modulate.a = lerpf(fadeRect.modulate.a, 0.0, 0.1 * delta)
		if fadeRect.modulate.a <= 0.1:
			fadeRect.hide()

func _on_player_update_shop_elements() -> void:
	for child in itemContainer.get_children():
		if child.has_method("updateElements"):
			child.updateElements()
