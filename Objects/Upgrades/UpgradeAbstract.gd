class_name UpgradeAbstract extends Resource

var name: String = "UpgradeName" : get = getName
var description: String = "UpgradeDescription" : get = getDescription

var price: int = 10 : get = getPrice
var maxLevel: int = 1000 : get = getMaxLevel, set = setMaxLevel
var level:int = 0 : get = getLevel, set = setLevel
var poisonessLevel: int = 0 : get = getPoisenLevel, set = setPoisenLevel

func _init(newName: String, newDescription: String, newPrice: int = 10, newMaxLevel: int = 1000) -> void:
	name = newName
	description = newDescription
	price = newPrice
	maxLevel = newMaxLevel
	
@warning_ignore("unused_parameter")
func executeAction(globalInstance: Node) -> int:
	return 0
	
@warning_ignore("unused_parameter")
func onClickAction(currentAmount:int, globalInstance: Node) -> int:
	return currentAmount

func getPrice() -> int:
	if level <= 0:
		return price
	return int(price * clamp(level, 2, maxLevel))

func getName() -> String:
	return name
	
func getDescription() -> String:
	return description

func getMaxLevel() -> int:
	return maxLevel
func setMaxLevel(newMaxLevel:int):
	maxLevel = newMaxLevel
	
func getLevel() -> int:
	return level
func setLevel(newLevel:int):
	level = newLevel
	level = clamp(level, 0, maxLevel)
func increaseLevel(amount:int):
	setLevel(level + amount)
	
func getPoisenLevel() -> int:
	return poisonessLevel
	
func setPoisenLevel(newLevel: int) -> void:
	poisonessLevel = newLevel
	
