class_name TimeDateManger extends Resource

var day: int = 1 : get = getDay
var month: int = 1 : get = getMonth
var year: int = 2088 : get = getYear
var hours: int = 1 : get = getHours
var minutes: int = 1 : get = getMinutes
var seconds: int = 1 : get = getSeconds

var msPass: int = Time.get_ticks_msec()

func update() -> void:
	var now: int = Time.get_ticks_msec()
	if now - msPass >= 500:
		msPass = now
		seconds += 1
	
	if seconds >= 60:
		minutes += 1
		seconds = 0
		
	if minutes >= 60:
		hours += 1
		minutes = 0
		
	if hours >= 24:
		day += 1
		hours = 0
	
	if day >= 30:
		month += 1
		day = 1
		
	if month >= 12:
		year += 1
		month = 1
		
func hasPassedTimeAndDate(date: Array) -> bool:
	if date.size() < 6:
		printerr("Invalid length provided within date array.")
		return false
	
	var dateAndTimeNow = getTimeDate()
	#for x in 
	return false
		
func offsetTimeAndDate(fromDate:Array, offsetAmountDate: Array) -> Array:
	if fromDate.size() < 6 or offsetAmountDate.size() < 6:
		printerr("Invalid length provided within date array.")
		return []
	
	var result: Array = []
	for value in range(0, fromDate.size()):
		result.append(fromDate[value] + offsetAmountDate[value])
		
	return result
		
func randomizeDateAndTime() -> void:
	day = randi_range(1, 28)
	month = randi_range(1, 3)
	hours = randi_range(1, 18)
	minutes = randi_range(1, 60)
	seconds = randi_range(1, 60)
		
func getTimeFormatted() -> String:
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
	
func getDateFormatted() -> String:
	return "%02d/%02d/%04d" % [day, month, year]
		
func getTimeDate() -> Array:
	return [day, month, year, hours, minutes, seconds]
		
func getDay() -> int:
	return day
	
func getMonth() -> int:
	return month
	
func getYear() -> int:
	return year
	
func getHours() -> int:
	return hours
	
func getMinutes() -> int:
	return minutes
	
func getSeconds() -> int:
	return seconds
	
func loadSavedData(savedData: Dictionary) -> void:
	if savedData.has("DateAndTime"):
		var sData: Array = savedData.get("DateAndTime")
		day = sData[0]
		month = sData[1]
		year = sData[2]
		hours = sData[3]
		minutes = sData[4]
		seconds = sData[5]
	else:
		randomizeDateAndTime()
		
func buildSaveDict() -> Dictionary:
	var dict: Dictionary = {}
	dict.set("DateAndTime", getTimeDate())
	return dict
