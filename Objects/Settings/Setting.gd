class_name Setting extends Node

var settingName: String = "SettingName" : get = getName
var settingValue : get = getValue
var settingValueType : get = getValueType
var updateCallable: Callable
var webHide: bool = false : get = isWebHidden

func _init(valueName: String, value, updateCall:Callable, newWebHide:bool = false) -> void:
	settingName = valueName
	settingValue = value
	settingValueType = typeof(value)
	updateCallable = updateCall
	webHide = newWebHide
	
func isWebHidden() -> bool:
	return webHide

func executeUpdate() -> void:
	if updateCallable:
		updateCallable.call(settingValue)

func getName() -> String:
	return settingName
	
func getValue():
	return settingValue
	
func getValueType():
	return settingValueType
	
func setValue(newValue):
	settingValue = newValue
	executeUpdate()
	
