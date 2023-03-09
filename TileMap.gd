extends TileMap
onready var globals = get_node("/root/global")
onready var map = globals.worldInfo[globals.currentPlanet]['world']['map']
var tileMapList = "globals.worldInfo[globals.currentPlanet]['world']['tileMapList']"
var renderedCells = []
var preRender = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#Orginal Seed 0

# Called when the node enters the scene tree for the first time.
func _ready():
	map = OpenSimplexNoise.new()
	map.period = 30

func isBetween(lowerBound, upperBound, num):
	if num > lowerBound:
		if num < upperBound:
			return true
		else:
			return false
	else: 
		return false

func render(startPos):
	var coords = [] #Positions to be rendered get added to this list
	for x in range(globals.renderDistance.x*2+1):
		for y in range(globals.renderDistance.y*2+1):
			coords.append(Vector2(startPos.x+x, startPos.y+y))
	for z in range(len(renderedCells)-1, 0, -1):
		if not renderedCells[z] in coords:
			set_cellv(renderedCells[z], -1)
			renderedCells.remove(z)
	for i in len(coords):
		var coord = coords[i]
		if not coord in renderedCells:
			renderedCells.append(coord)
			if not coord in globals.worldInfo[globals.currentPlanet]['world']['tileMapList'].keys():
				var setValue = null
				if coord.y < 8:
					setValue = -8
				elif coord.y == 8:
					setValue = -5
				else:
					setValue = map.get_noise_2dv(coord)
				globals.worldInfo[globals.currentPlanet]['world']['tileMapList'][coord] = setValue
			var squareValue = globals.worldInfo[globals.currentPlanet]['world']['tileMapList'][coord]
			if isBetween(0.325, 0.375, squareValue):
				set_cell(coord.x, coord.y, 0)
			elif squareValue == -8: #-10 represents air
				set_cell(coord.x, coord.y, -1)
			elif squareValue == -5:  #-5 represents the ground
				set_cell(coord.x, coord.y, 2)
			else:
				set_cell(coord.x, coord.y, 1)

