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
	
	if year > date[2]:
		return true
	elif month > date[1]:
		return true
	elif day == date[0]:
		if hours > date[3]:
			return true
		elif hours == date[3]:
			if  minutes == date[4] or seconds > date[5]:
				return true
			elif minutes > date[4]:
				return true
	return false
		
func offsetTimeAndDate(fromDate:Array, offsetAmountDate: Array) -> Array:
	if fromDate.size() < 6 or offsetAmountDate.size() < 6:
		printerr("Invalid length provided within date and time array. Must have 6 values of, Day/Month/Year/Hour/Minutes/Seconds")
		return []
	
	var maxValues: Array = [30, 12, -1, 24, 60, 60 ]
	#Date Offsetting and Addition
	var carryAmount: int = 0
	var result: Array = []
	for value in range(0, 3):
		var addition = fromDate[value] + offsetAmountDate[value] + carryAmount
		if maxValues[value] != -1 and addition >= maxValues[value]:
			carryAmount = roundi(addition / maxValues[value])
			var sub: int = addition - maxValues[value]
			if sub <= 0:
				sub = 1
			result.append(sub)
			continue
			
		result.append(addition)
		carryAmount = 0
	
	#Time Offsetting and Addition
	var index = 5
	var resultTime: Array = []
	var dayAddition = 0
	while index != 2:
		var addition = fromDate[index] + offsetAmountDate[index] + carryAmount
		if addition >= maxValues[index]:
			carryAmount = floor(addition / maxValues[index])
			if index == 3:
				dayAddition = carryAmount
			resultTime.append(addition - maxValues[index])
			index -= 1
			continue
			
		resultTime.append(clamp(addition, 0, maxValues[index]))
		carryAmount = 0
		index -= 1
	
	if dayAddition != 0:
		result[0] += dayAddition
	
	resultTime.reverse()
	result.append_array(resultTime)
	return result
		
func randomizeDateAndTime() -> void:
	day = randi_range(1, 28)
	month = randi_range(1, 3)
	hours = randi_range(1, 18)
	minutes = randi_range(1, 60)
	seconds = randi_range(1, 60)
		
func getTimeFormatted(dateArray: Array = []) -> String:
	if dateArray.size() == 6:
		return "%02d:%02d:%02d" % [dateArray[3], dateArray[4], dateArray[5]]
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
	
func getDateFormatted(dateArray: Array = []) -> String:
	if dateArray.size() == 6:
		return "%02d/%02d/%04d" % [dateArray[0], dateArray[1], dateArray[2]]
	return "%02d/%02d/%04d" % [day, month, year]
	
func getDateTimeFormatted(dateArray: Array = []) -> String:
	if dateArray.size() == 6:
		return "%02d/%02d/%04d - %02d:%02d:%02d" % [dateArray[0], dateArray[1], dateArray[2], dateArray[3], dateArray[4], dateArray[5]]
	return "%02d/%02d/%04d - %02d:%02d:%02d" % [day, month, year, hours, minutes, seconds]
		
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
