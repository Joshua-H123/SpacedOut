extends Node2D
onready var globals = get_node("/root/global")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$saveTimer.start()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST: #Runs when the user closes the window
		save()
		get_tree().quit()

func save(): #Handles the saving of the game
	var file = File.new()
	file.open("user://saveData.txt", File.WRITE)
	file.store_string(to_json({'world':globals.worldInfo[globals.currentPlanet]['world']['tileMapList'], 'playerPos':$Player.getSavePos()}))
	file.close()

func _on_saveTimer_timeout(): #Runs when the save timer reaches 0
	save()
