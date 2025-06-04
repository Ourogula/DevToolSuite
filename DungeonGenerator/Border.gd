extends TextureButton

var x:int
var y:int
var z:int
var direction:int
var borderType:int
var originalModulate:Color
const img:Texture2D = preload("res://DungeonGenerator/Blank.png")

func _ready():
  texture_normal = img
  stretch_mode = TextureButton.STRETCH_SCALE
  ignore_texture_size = true
  originalModulate = self_modulate

func _set_location(xVal:int, yVal:int, zVal:int,dir:int):
  x = xVal
  y = yVal
  z = zVal
  direction = dir

func _set_border_type(newType:int):
  borderType = newType
  if (newType == 1):
    self_modulate = Color.BLACK
    originalModulate = self_modulate
  elif (newType == 2):
    self_modulate = Color.WHITE
    originalModulate = self_modulate

func _flip_border_type():
  if (borderType < 2):
    _set_border_type(borderType + 1)
  else:
    _set_border_type(1)

func _on_pressed():
  _flip_border_type()

func _on_mouse_over():
  self_modulate = Color.YELLOW
  
func _on_mouse_off():
  self_modulate = originalModulate
