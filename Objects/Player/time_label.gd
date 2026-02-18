extends Label

@onready var global:Node = $"/root/Global"

var timeDateManagerRef: TimeDateManger
var msPass: int = Time.get_ticks_msec()
var flashToggle: bool = false

func _ready() -> void:
	timeDateManagerRef = global.getTimeDateManager()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if timeDateManagerRef:
		timeDateManagerRef.update()
		var label = timeDateManagerRef.getTimeFormatted()
		
		var now: int = Time.get_ticks_msec()
		if now - msPass >= 500:
			msPass = now
			flashToggle = !flashToggle
			
		if flashToggle:
			label = label.replace(":", " ")
		set_text(label)
