extends TextureButton

var X: int
var Y: int
var Z: int
# 0 for horizontal, 1 for vertical
var CellType:int
var oldModulate:Color

var RoomNumber:int

# Cell.gd
func _set_cell(x: int, y: int, z: int, cellType: int, room:int):
  X = x
  Y = y
  Z = z
  CellType = cellType
  ignore_texture_size = true
  stretch_mode = TextureButton.STRETCH_SCALE
  oldModulate = self_modulate
  RoomNumber = room
  get_node("Label").text = str(room)

func _reset_modulate():
  self_modulate = oldModulate
