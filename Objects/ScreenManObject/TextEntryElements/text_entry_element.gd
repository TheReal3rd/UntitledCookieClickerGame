extends HBoxContainer

@onready var nameLabel: Label = $NameLabel
@onready var messageLabel: Label = $MessageLabel
@onready var spacerLabel:Label = $Spacer

var postersName:String = "" : set = setName
var postersMessage:String = "This is a template message." : set = setMessage

func _ready() -> void:
	nameLabel.set_text(postersName)
	messageLabel.set_text(postersMessage)
	
func setName(newName) -> void:
	postersName = newName
	await ready
	if is_node_ready():
		spacerLabel.show()
		nameLabel.set_text(postersName)

func setMessage(newMessage) -> void:
	postersMessage = newMessage
	await ready
	if is_node_ready():
		messageLabel.set_text(postersMessage)
