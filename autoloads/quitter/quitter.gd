extends Node

signal quitting

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit()

func quit() -> void:
	quitting.emit()
	await get_tree().process_frame
	get_tree().quit()
