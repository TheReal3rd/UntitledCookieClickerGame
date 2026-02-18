extends Node


func findClosest(fromObject: Node3D, toObjects: Array):
	var closestDist: float = 1000000000
	var closestObject: Node3D
	for obj in toObjects:
		var tempDist:float = fromObject.get_global_position().distance_to(obj.get_global_position())
		if tempDist < closestDist:
			closestDist = tempDist
			closestObject = obj
	return closestObject 
