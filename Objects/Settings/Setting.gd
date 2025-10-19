class_name Setting extends Node

var settingName: String = "SettingName" : get = getName
var settingValue : get = getValue
var settingValueType : get = getValueType

func _init(valueName: String, value) -> void:
	settingName = valueName
	settingValue = value
	settingValueType = typeof(value)

func getName() -> String:
	return settingName
	
func getValue():
	return settingValue
	
func getValueType():
	return settingValueType
	
func setValue(newValue):
	settingValue = newValue
	
