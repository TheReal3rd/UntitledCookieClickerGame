extends VBoxContainer

@onready var nameLabel = $HSplitContainer/NameLabel
@onready var priceLabel = $HSplitContainer/PriceLabel
@onready var levelLabel = $HSplitContainer/LevelLabel
@onready var buyButton = $HSplitContainer/BuyButton
@onready var global = $"/root/Global"

var upgradeObject: UpgradeAbstract : set = setUpgrade, get = getUpgrade

func _ready() -> void:
	updateElements()

func updateElements():
	if is_node_ready() and upgradeObject:
		nameLabel.set_text(upgradeObject.getName())
		priceLabel.set_text("| Price: %d |" % upgradeObject.getPrice())
		levelLabel.set_text(" Level: %d " % upgradeObject.getLevel())
		if global.getScore() >= upgradeObject.getPrice() and upgradeObject.getLevel() < upgradeObject.getMaxLevel():
			buyButton.show()
		else:
			buyButton.hide()

func setUpgrade(newUpgrade: UpgradeAbstract) -> void:
	upgradeObject = newUpgrade
	updateElements()
		
func getUpgrade() -> UpgradeAbstract:
	return upgradeObject

func _on_buy_button_pressed() -> void:
	if global.getScore() >= upgradeObject.getPrice():
		global.changeScore(-upgradeObject.getPrice())
		upgradeObject.increaseLevel(1)
	var tempPlayer: Node = global.getPlayer()
	if tempPlayer:
		tempPlayer.emit_signal("updateShopElements")


func _on_name_label_mouse_entered() -> void:
	pass # Replace with function body.
