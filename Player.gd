extends KinematicBody2D
onready var globals = get_node("/root/global")
onready var planetInfo = globals.worldInfo[globals.currentPlanet]
onready var gravity = planetInfo['world']['gravity']
onready var jumpAmount = gravity*-30
onready var playerInfo = globals.playerInfo
onready var movementSpeed = playerInfo['movementSpeed']
onready var tileMap = get_parent().get_node("TileMap")

var velocity = Vector2.ZERO
# warning-ignore:unused_argument

func _ready():
	position = globals.playerPosition

func _physics_process(delta):
	velocity.y += gravity
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpAmount
	if Input.is_action_pressed('moveRight'):
		velocity.x += movementSpeed/4
	if Input.is_action_pressed('moveLeft'):
		velocity.x -= movementSpeed/4
	if not Input.is_action_pressed("moveRight") and not Input.is_action_pressed("moveLeft") and velocity.x != 0:
		velocity.x += movementSpeed/4*(velocity.x/abs(velocity.x)*-1)
	velocity.y = clamp(velocity.y, jumpAmount, gravity*25)
	velocity.x = clamp(velocity.x, -movementSpeed, movementSpeed)
	var tileMapPos = getTileMapPos(position)
	var startPos = Vector2(tileMapPos.x-globals.renderDistance.x, tileMapPos.y-globals.renderDistance.y)

	tileMap.render(startPos)
	if Input.is_action_pressed("mine"):
		
		var rawPos = get_viewport().get_mouse_position()
		var cameraPos = $Camera2D.get_camera_position()
		var minePos = getTileMapPos(Vector2(rawPos.x+cameraPos.x-532, rawPos.y+cameraPos.y-300))
		var mineStartPos = Vector2(minePos.x-globals.mineRadius, minePos.y-globals.mineRadius)
		for x in range(globals.mineRadius*2+1):
			for y in range(globals.mineRadius*2+1):
				var pos = Vector2(mineStartPos.x + x, mineStartPos.y+y)
				globals.worldInfo[globals.currentPlanet]['world']['tileMapList'][pos] = -8
				tileMap.set_cellv(pos, -1)

	move_and_slide(velocity, Vector2.UP)
	globals.playerPosition = position
	
func getSavePos():
	return [position.x, position.y]
	
	
func getTileMapPos(coords): #Accepts coordinates as a vector and returns the coordinate of the tilemap
	return Vector2(round(coords.x/tileMap.cell_size.x/tileMap.scale.x), int(coords.y/tileMap.cell_size.y/tileMap.scale.y))
	
