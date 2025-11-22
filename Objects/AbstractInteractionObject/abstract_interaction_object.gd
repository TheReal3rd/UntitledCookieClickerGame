class_name AbstractInteractionObject extends StaticBody3D

@warning_ignore("unused_signal")
signal closeGUI
@warning_ignore("unused_signal")
signal openGUI

var unlocked: bool = true : get = isUnlocked, set = setUnlocked
var beenActivated: bool = false : get = isBeenActivated
var activate: bool = false : set = setActive, get = isActive

func isUnlocked():
	return unlocked
	
func setUnlocked(newState):
	unlocked = newState
	
func unlock():
	unlocked = true

func isBeenActivated():
	return beenActivated
	
func setActive(newState):
	activate = newState
	if newState:
		beenActivated = true
		
func isActive():
	return activate
	
