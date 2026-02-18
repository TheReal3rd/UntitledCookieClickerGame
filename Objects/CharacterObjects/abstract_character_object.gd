class_name AbstractCyborgCharacter extends CharacterBody3D

@export var maxHealth: int = 100 : get = getMaxHealth
@export var health:int = 100 : get = getHealth, set = setHealth

@export var noAI: bool = false

enum IdleTasks {
	None,
	Patrol
}

enum GeneralTasks {
	Attack,
	LookAt,
	None
}

@export var currentIdleTask : IdleTasks = IdleTasks.None
@export var currentPlayerTask : GeneralTasks = GeneralTasks.None
@export var currentNemeyTask: GeneralTasks = GeneralTasks.None

@export var minDistanceMove: float = 5.0
@export var minDistanceAttack: float = 10


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func getMaxHealth() -> int:
	return maxHealth
	
func getHealth() -> int:
	return health
	
func setHealth(newValue) -> void:
	health = clamp(newValue, 0, maxHealth)
