extends Control

var mapX:TextEdit
var mapY:TextEdit

var mapXCurrentValue:int
var mapYCurrentValue:int
var mapGrid:GridContainer
var currentGridValues:Dictionary = {}

var cellSize:int
var selectedCellType:int

#1 - Hallway
var hallwayTexture:AtlasTexture = preload("res://HallwayTexture.tres")
#2 - Enemy
var enemyTexture:AtlasTexture = preload("res://EnemyTexture.tres")
#3 - Exit
var exitTexture:AtlasTexture = preload("res://ExitTexture.tres")
#4 - Entrance
var entranceTexture:AtlasTexture = preload("res://EntranceTexture.tres")
#5 - Starwell
var stairwellTexture:AtlasTexture = preload("res://StairwellTexture.tres")
#6 - Wall
var wallTexture:Texture2D = preload("res://icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready():
  mapX = get_node("Inputs/MapX");
  mapXCurrentValue = int(mapX.text);
  mapY = get_node("Inputs/MapY");
  mapYCurrentValue = int(mapY.text);
  mapGrid = get_node("Map/Grid");
  cellSize = min((1000 / max(mapXCurrentValue, mapYCurrentValue)), 75)
  GenerateStarterMap()
  FillMapGrid()

func GenerateStarterMap():
  mapGrid.columns = mapXCurrentValue
  for y in range(1, mapYCurrentValue + 1):
    for x in range(1, mapXCurrentValue + 1):
      var key = '[%s,%s]' % [x,y]
      currentGridValues[key] = 5
      
func UpdateGridValues():
  mapGrid.columns = mapXCurrentValue
  var newDict:Dictionary = {}
  for y in range(1, mapYCurrentValue + 1):
    for x in range(1, mapXCurrentValue + 1):
      var key = '[%s,%s]' % [x,y]
      if (currentGridValues.has(key)):
        newDict[key] = currentGridValues[key]
      else:
        newDict[key] = 5
      
  currentGridValues = newDict
  
func ClearGridContainer():
  for child in mapGrid.get_children():
    child.queue_free();
    
func FillMapGrid():
  for y in range(1, mapYCurrentValue + 1):
    for x in range(1, mapXCurrentValue + 1):
      var key = '[%s,%s]' % [x,y]
      AddGridCell(currentGridValues[key],x,y)
      
func AddGridCell(cellType:int, x:int, y:int):
  var cell = TextureButton.new()
  cell.ignore_texture_size = true
  cell.stretch_mode = TextureButton.STRETCH_SCALE
  cell.custom_minimum_size = Vector2(cellSize, cellSize)
  if cellType < 1 || cellType > 6:
    pass
  else:
    SetCellTexture(cell, cellType)
    
  cell.name = '[%s,%s]' % [x,y]
  cell.connect("pressed", Callable(self, "_on_grid_cell_clicked").bind(cell))
  mapGrid.add_child(cell)

func _on_hallway_pressed():
  selectedCellType = 1

func _on_enemy_pressed():
  selectedCellType = 2

func _on_exit_pressed():
  selectedCellType = 3

func _on_entrance_pressed():
  selectedCellType = 4

func _on_stairwell_pressed():
  selectedCellType = 5

func _on_wall_pressed():
  selectedCellType = 6

func _on_update_button_pressed():
  var mapXChanged:int = int(mapX.text);
  var mapYChanged:int = int(mapY.text);
  
  if (mapXChanged != mapXCurrentValue || mapYChanged != mapYCurrentValue):
    mapXCurrentValue = mapXChanged;
    mapYCurrentValue = mapYChanged;
    cellSize = min((1000 / max(mapXCurrentValue, mapYCurrentValue)), 75)
    ClearGridContainer()
    UpdateGridValues()
    FillMapGrid()

func _on_grid_cell_clicked(cell:TextureButton):
  if selectedCellType != 0:
    var n = cell.name
    currentGridValues[n] = selectedCellType
    SetCellTexture(cell, selectedCellType)

func _input(event):
  if event is InputEventMouseButton:
    if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
      selectedCellType = 0
      
func SetCellTexture(cell:TextureButton, cellType:int):
  if (cellType == 1):
    cell.texture_normal = hallwayTexture
  elif (cellType == 2):
    cell.texture_normal = enemyTexture
  elif (cellType == 3):
    cell.texture_normal = exitTexture
  elif (cellType == 4):
    cell.texture_normal = entranceTexture
  elif (cellType == 5):
    cell.texture_normal = stairwellTexture
  elif (cellType == 6):
    cell.texture_normal = wallTexture
    cell.self_modulate = Color.BLACK

func CreateDungeonScript():
  pass
