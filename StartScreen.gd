extends Control
onready var globals = get_node("/root/global")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_newButton_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_loadButton_pressed():
	var file = File.new()
	#file.open("user://Documents/saveGames/saveData.txt", File.READ_WRI TE)
	file.open("user://saveData.txt", File.READ_WRITE)
	var content = parse_json(file.get_as_text())
	file.close()
	#Converts the string keys to Vector2 keys
	var strWorldInfo = content['world']
	var worldCoords = []
	var worldInfo = {}
	for key in strWorldInfo.keys():
		var splitKey = key.split(',')
		splitKey[0] = splitKey[0].substr(1)
		splitKey[1] = splitKey[1].substr(1, len(splitKey[1])-2)
		worldInfo[Vector2(splitKey[0], splitKey[1])] = strWorldInfo[key]
		
	globals.worldInfo[globals.currentPlanet]['world']['tileMapList'] = worldInfo
	get_tree().change_scene("res://World.tscn")
	globals.playerPosition = Vector2(content['playerPos'][0], content['playerPos'][1])
