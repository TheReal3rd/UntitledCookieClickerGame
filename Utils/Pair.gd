class_name Pair extends Resource

var first = null : get = getFirst, set = setFirst
var second = null : get = getSecond, set = setSecond

func _init(newFirst, newSecond) -> void:
	first = newFirst
	second = newSecond
	
func getFirst():
	return first

func setFirst(newFirst):
	first = newFirst
	
func getSecond():
	return second
	
func setSecond(newSecond):
	second = newSecond
