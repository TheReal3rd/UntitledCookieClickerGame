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

func listFiles(path: String) -> Array[String]:
	var fileNames: Array[String] = []
	var dir := DirAccess.open(path)
	if dir == null:
		printerr("Error directory wasn't found.")
		return []
	
	dir.list_dir_begin()
	var fileName = dir.get_next()
	while fileName != "":
		if dir.current_is_dir():
			continue
		fileNames.append(fileName)
		fileName = dir.get_next()
	dir.list_dir_end()
	return fileNames
