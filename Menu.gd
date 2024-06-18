extends Control

var calculator

# Called when the node enters the scene tree for the first time.
func _ready():
  calculator = get_node("Calculator")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_calculator_pressed():
  var calculator_scene = preload("res://Calculator.tscn").instantiate()
  get_tree().root.add_child(calculator_scene)
