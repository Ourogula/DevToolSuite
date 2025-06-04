extends Control

const Cell = preload("res://DungeonGenerator/Cell.tscn")
const CellScript = preload("res://DungeonGenerator/Cell.gd")
const Border = preload("res://DungeonGenerator/Border.gd")
const RoomSelect = preload("res://DungeonGenerator/RoomSelect.tscn")

var dungeonName:String
var dungeonNameEdit:TextEdit

# Dungeon Size inputs
var mapX:TextEdit
var mapY:TextEdit
var mapZ:TextEdit

# Current values for the map size inputs
var mapXCurrentValue:int
var mapYCurrentValue:int
var mapZCurrentValue:int

# Cell Values
var mapGrid:GridContainer
var currentGridValues:Dictionary = {}

# Border Values
var vBorderColumns:GridContainer
var hBorderColumns:GridContainer
var allBorders:Dictionary = {}

# Size of each individual cell based on the map size
# This is calculated to ensure the grid fits within the screens area
var cellSize:int
var selectedCellType:int
var selectedRoom:int
var rooms = []
var roomSelectColumn:GridContainer

#1 - Hallway
var hallwayTexture:AtlasTexture = preload("res://DungeonGenerator/HallwayTexture.tres")
#2 - Enemy
var enemyTexture:AtlasTexture = preload("res://DungeonGenerator/EnemyTexture.tres")
#3 - Exit
var exitTexture:AtlasTexture = preload("res://DungeonGenerator/ExitTexture.tres")
#4 - Entrance
var entranceTexture:AtlasTexture = preload("res://DungeonGenerator/EntranceTexture.tres")
#5 - Starwell
var stairwellTexture:AtlasTexture = preload("res://DungeonGenerator/StairwellTexture.tres")
#6 - Wall
var wallTexture:Texture2D = preload("res://icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready():
  dungeonNameEdit = get_node("Inputs/DungeonName")
  dungeonName = dungeonNameEdit.text
  mapX = get_node("Inputs/MapX");
  mapXCurrentValue = int(mapX.text);
  mapY = get_node("Inputs/MapY");
  mapYCurrentValue = int(mapY.text);
  mapZ = get_node("Inputs/MapZ");
  mapZCurrentValue = int(mapZ.text);
  mapGrid = get_node("Map/Grid");
  vBorderColumns = get_node("Map/VerticalBorders")
  hBorderColumns = get_node("Map/HorizontalBorders")
  roomSelectColumn = get_node("Rooms")
  cellSize = min((1000 / max(mapXCurrentValue, mapYCurrentValue)), 75)
  selectedCellType = 0
  selectedRoom = -1
  UpdateGridValues()
  UpdateBorderValues()
  FillMapGrid()
  FillBorders()
  AddRoom()

func UpdateGridValues():
  mapGrid.columns = mapXCurrentValue
  var newDict:Dictionary = {}
  for y in range(0, mapYCurrentValue):
    for x in range(0, mapXCurrentValue):
      var key = [x,y,mapZCurrentValue]
      if (currentGridValues.has(key)):
        var newCell = Cell.instantiate()
        var oldCell = currentGridValues[key]
        newCell._set_cell(oldCell.X,oldCell.Y,oldCell.Z,oldCell.CellType,oldCell.RoomNumber)
        newCell.name = oldCell.name
        newDict[key] = newCell
      else:
        var newCell = Cell.instantiate()
        newCell._set_cell(x,y,mapZCurrentValue,1,1)
        newCell.name = '[%s,%s,%s]' % [x,y,mapZCurrentValue]
        newDict[key] = newCell
      
  currentGridValues = newDict
  
func UpdateBorderValues():
  vBorderColumns.columns = mapXCurrentValue + 1
  hBorderColumns.columns = mapXCurrentValue
  
  vBorderColumns.add_theme_constant_override("h_separation", cellSize - (cellSize / 7))
  hBorderColumns.add_theme_constant_override("v_separation", cellSize - (cellSize / 7))
  
  var newDict:Dictionary = {}
  # There are 1 more border per X and Y than there are cells
  for y in range(0, mapYCurrentValue + 1):
    for x in range(0, mapXCurrentValue + 1):
      if (x == mapXCurrentValue or y == mapYCurrentValue):
        if (x == mapXCurrentValue and y == mapYCurrentValue):
          continue
        elif (x == mapXCurrentValue):
          if (allBorders.has([x,y,mapZCurrentValue,0])):
            var oldBorder = allBorders[[x,y,mapZCurrentValue,0]]
            var border = Border.new()
            border.name = oldBorder.name
            border._set_location(x,y,mapZCurrentValue,0)
            border._set_border_type(oldBorder.borderType)
            border.custom_minimum_size = Vector2(cellSize / 7, cellSize)
            newDict[[x,y,mapZCurrentValue,0]] = border
          else:
            var key1 = '[%s,%s,%s,%s]' % [x,y,mapZCurrentValue,0]
            var border = Border.new()
            border.name = key1
            border._set_location(x,y,mapZCurrentValue,0)
            border._set_border_type(1)
            border.custom_minimum_size = Vector2(cellSize / 7, cellSize)
            newDict[[x,y,mapZCurrentValue,0]] = border
        else:
          if (allBorders.has([x,y,mapZCurrentValue,1])):
            var oldBorder = allBorders[[x,y,mapZCurrentValue,1]]
            var border = Border.new()
            border.name = oldBorder.name
            border._set_location(x,y,mapZCurrentValue,1)
            border._set_border_type(oldBorder.borderType)
            border.custom_minimum_size = Vector2(cellSize, cellSize / 7)
            newDict[[x,y,mapZCurrentValue,1]] = border
          else:
            var key2 = '[%s,%s,%s,%s]' % [x,y,mapZCurrentValue,1]
            var border = Border.new()
            border.name = key2
            border._set_location(x,y,mapZCurrentValue,1)
            border._set_border_type(1)
            border.custom_minimum_size = Vector2(cellSize, cellSize / 7)
            newDict[[x,y,mapZCurrentValue,1]] = border
      else:
        if (allBorders.has([x,y,mapZCurrentValue,0])):
          var oldBorder = allBorders[[x,y,mapZCurrentValue,0]]
          var border = Border.new()
          border.name = oldBorder.name
          border._set_location(x,y,mapZCurrentValue,0)
          border._set_border_type(oldBorder.borderType)
          border.custom_minimum_size = Vector2(cellSize / 7, cellSize)
          newDict[[x,y,mapZCurrentValue,0]] = border
        else:
          var key1 = '[%s,%s,%s,%s]' % [x,y,mapZCurrentValue,0]
          var border = Border.new()
          border.name = key1
          border._set_location(x,y,mapZCurrentValue,0)
          border._set_border_type(1)
          border.custom_minimum_size = Vector2(cellSize / 7, cellSize)
          newDict[[x,y,mapZCurrentValue,0]] = border
          
        if (allBorders.has([x,y,mapZCurrentValue,1])):
          var oldBorder = allBorders[[x,y,mapZCurrentValue,1]]
          var border = Border.new()
          border.name = oldBorder.name
          border._set_location(x,y,mapZCurrentValue,1)
          border._set_border_type(oldBorder.borderType)
          border.custom_minimum_size = Vector2(cellSize, cellSize / 7)
          newDict[[x,y,mapZCurrentValue,1]] = border
        else:
          var key2 = '[%s,%s,%s,%s]' % [x,y,mapZCurrentValue,1]
          var border = Border.new()
          border.name = key2
          border._set_location(x,y,mapZCurrentValue,1)
          border._set_border_type(1)
          border.custom_minimum_size = Vector2(cellSize, cellSize / 7)
          newDict[[x,y,mapZCurrentValue,1]] = border
        
  allBorders = newDict
  
func ClearGridContainer():
  for child in mapGrid.get_children():
    child.queue_free();
    
func ClearBorders():
  for child in vBorderColumns.get_children():
    if (!allBorders.has(child)):
      child.queue_free()
  for child in hBorderColumns.get_children():
    if (!allBorders.has(child)):
      child.queue_free()
    
func FillMapGrid():
  for y in range(0, mapYCurrentValue):
    for x in range(0, mapXCurrentValue):
      var key = [x,y,mapZCurrentValue]
      AddGridCell(currentGridValues[key])
      
func FillBorders():
  for y in range(0, mapYCurrentValue + 1):
    for x in range(0, mapXCurrentValue + 1):
      if (x == mapXCurrentValue and y == mapYCurrentValue):
        continue
      elif (x == mapXCurrentValue):
        AddBorder(allBorders[[x,y,mapZCurrentValue,0]])
      elif (y == mapYCurrentValue):
        AddBorder(allBorders[[x,y,mapZCurrentValue,1]]) 
      else:
        AddBorder(allBorders[[x,y,mapZCurrentValue,0]])
        AddBorder(allBorders[[x,y,mapZCurrentValue,1]])  
      
func AddGridCell(cell:CellScript):
  cell.custom_minimum_size = Vector2(cellSize, cellSize)
  if cell.CellType < 1 || cell.CellType > 6:
    pass
  else:
    SetCellTexture(cell)
    
  cell.connect("pressed", Callable(self, "_on_grid_cell_clicked").bind(cell))
  mapGrid.add_child(cell)
  
func AddBorder(border:Border):
  border.connect("pressed", Callable(border, "_flip_border_type"))
  border.connect("mouse_entered", Callable(border, "_on_mouse_over"))
  border.connect("mouse_exited", Callable(border, "_on_mouse_off"))
  if (border.direction == 0):
    vBorderColumns.add_child(border)
  else:
    hBorderColumns.add_child(border)

func _on_hallway_pressed():
  print('Selected 1')
  selectedCellType = 1

func _on_enemy_pressed():
  print('Selected 2')
  selectedCellType = 2

func _on_exit_pressed():
  print('Selected 3')
  selectedCellType = 3

func _on_entrance_pressed():
  print('Selected 4')
  selectedCellType = 4

func _on_stairwell_pressed():
  print('Selected 5')
  selectedCellType = 5

func _on_wall_pressed():
  print('Selected 6')
  selectedCellType = 6

func _on_update_button_pressed():
  var mapXChanged:int = int(mapX.text);
  var mapYChanged:int = int(mapY.text);
  var mapZChanged:int = int(mapZ.text);
  dungeonName = dungeonNameEdit.text;
  
  if (mapXChanged != mapXCurrentValue || mapYChanged != mapYCurrentValue || mapZChanged):
    mapXCurrentValue = mapXChanged;
    mapYCurrentValue = mapYChanged;
    mapZCurrentValue = mapZChanged;
    
    cellSize = min((1000 / max(mapXCurrentValue, mapYCurrentValue)), 75)
    ClearGridContainer()
    UpdateGridValues()
    UpdateBorderValues()
    ClearBorders()
    FillMapGrid()
    FillBorders()

func _on_grid_cell_clicked(cell:CellScript):
  if (selectedCellType != 0):
    cell.CellType = selectedCellType
    
  if (selectedRoom != -1):
    cell.RoomNumber = selectedRoom
    
  cell.get_node("Label").text = str(cell.RoomNumber)
  SetCellTexture(cell)

func _input(event):
  if event is InputEventMouseButton:
    if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
      selectedCellType = 0
      selectedRoom = -1
  elif event is InputEventKey:
    if event.pressed and event.keycode == KEY_KP_ADD:
      AddRoom()
    elif event.pressed and event.keycode == KEY_KP_SUBTRACT:
      RemoveRoom()
      
func SetCellTexture(cell:CellScript):

  if (cell.CellType == 1):
    cell.texture_normal = hallwayTexture
    cell._reset_modulate()
  elif (cell.CellType == 2):
    cell.texture_normal = enemyTexture
    cell._reset_modulate()
  elif (cell.CellType == 3):
    cell.texture_normal = exitTexture
    cell._reset_modulate()
  elif (cell.CellType == 4):
    cell.texture_normal = entranceTexture
    cell._reset_modulate()
  elif (cell.CellType == 5):
    cell.texture_normal = stairwellTexture
    cell._reset_modulate()
  elif (cell.CellType == 6):
    cell.texture_normal = wallTexture
    cell.self_modulate = Color.BLACK

func _on_check_button_toggled(borderMode:bool):
  if (borderMode):
    vBorderColumns.mouse_filter = Control.MOUSE_FILTER_STOP
  else:
    vBorderColumns.mouse_filter = Control.MOUSE_FILTER_IGNORE
    
func SetSelectedRoom(roomNumber:int):
  print('Selected Room [%s]' % [roomNumber])
  selectedRoom = roomNumber

func AddRoom():
  var next
  if (len(rooms) == 0):
    next = 0
  else:
    next = rooms.back() + 1
    
  rooms.append(next)
  
  roomSelectColumn.columns = max((len(rooms) / 15) + 1, 1) 
  
  var newRoomButton = RoomSelect.instantiate()
  newRoomButton.connect("pressed", Callable(self, "SetSelectedRoom").bind(next))
  newRoomButton.name = str(next)
  newRoomButton.get_node("Label").text = str(next)
  roomSelectColumn.add_child(newRoomButton)
  roomSelectColumn.move_child(newRoomButton, next - 1)

func RemoveRoom():
  if (len(rooms) == 0):
    return
  else:
    var max = rooms.pop_back()
    roomSelectColumn.get_node(str(max)).queue_free()
    roomSelectColumn.columns = max((len(rooms) / 15) + 1, 1) 

func CreateDungeonScript():
  var output = get_node("Inputs/Output")
  var outputStr = ""
  
  var roomDictSorted = {}
  
  for c in currentGridValues:
    if (roomDictSorted.has(currentGridValues[c].RoomNumber)):
      roomDictSorted[currentGridValues[c].RoomNumber].append(currentGridValues[c])
    else:
      roomDictSorted[currentGridValues[c].RoomNumber] = [currentGridValues[c]]
      
  for r in roomDictSorted:
    outputStr += GenerateRoomString(r, roomDictSorted)
  
  output.text = outputStr
  output.visible = true

func GenerateCellString(cell:CellScript):
  var cellStr = ""
  var topBorder = allBorders[[cell.X, cell.Y, cell.Z, 1]]
  var bottomBorder = allBorders[[cell.X, cell.Y + 1, cell.Z, 1]]
  var westBorder = allBorders[[cell.X, cell.Y, cell.Z, 0]]
  var eastBorder = allBorders[[cell.X + 1, cell.Y, cell.Z, 0]]
  
  var topStr = ""
  if (topBorder.borderType == 1):
    topStr = "border.WALL"
  elif (topBorder.borderType == 2):
    topStr = "border.OPEN"
    
  var bottomStr = ""
  if (bottomBorder.borderType == 1):
    bottomStr = "border.WALL"
  elif (bottomBorder.borderType == 2):
    bottomStr = "border.OPEN"
  
  var westStr = ""
  if (westBorder.borderType == 1):
    westStr = "border.WALL"
  elif (westBorder.borderType == 2):
    westStr = "border.OPEN"
    
  var eastStr = ""
  if (eastBorder.borderType == 1):
    eastStr = "border.WALL"
  elif (eastBorder.borderType == 2):
    eastStr = "border.OPEN"
    
  cellStr += "new(%s, %s, %s, %s, %s, %s, %s),\n" % [cell.X, cell.Y, cell.Z, topStr, eastStr, bottomStr, westStr]
  return cellStr

func GenerateRoomString(roomNumber:int, roomDict:Dictionary):
  var roomStr = ""
  roomStr += "{ %s, new(%s, [], new List<Cell>{\n" % [roomNumber, roomNumber]
  for c in roomDict[roomNumber]:
    roomStr += GenerateCellString(c)
  
  roomStr += "})},\n"
  return roomStr
