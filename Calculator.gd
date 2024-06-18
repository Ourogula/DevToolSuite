extends Control

var attack
var defense
var magic
var resistance
var health
var intelligence
var control
var speed

var attack_label
var defense_label
var magic_label
var resistance_label
var health_label
var intelligence_label
var control_label
var speed_label

var attack_current
var defense_current
var magic_current
var resistance_current
var health_current
var intelligence_current
var control_current
var speed_current

var remaining_points
var character_name

var attack_cost = 2
var defense_cost = 2
var magic_cost = 2
var resistance_cost = 2
var health_cost = 1
var intelligence_cost = 2
var control_cost = 1
var speed_cost = 1

var attack_base = 10
var defense_base = 10
var magic_base = 10
var resistance_base = 10
var health_base = 50
var intelligence_base = 10
var control_base = 10
var speed_base = 10
var remaining_points_base = 50

# Called when the node enters the scene tree for the first time.
func _ready():
  attack = get_node("PC/VBC1/Attack")
  defense = get_node("PC/VBC1/Defense")
  magic = get_node("PC/VBC1/Magic")
  resistance = get_node("PC/VBC1/Resistance")
  health = get_node("PC/VBC1/Health")
  intelligence = get_node("PC/VBC1/Intelligence")
  control = get_node("PC/VBC1/Control")
  speed = get_node("PC/VBC1/Speed")
  character_name = get_node("PC/VBC1/HBC2/Name")
  
  attack_label = get_node("PC/VBC1/AttackLabel")
  defense_label = get_node("PC/VBC1/Defense Label")
  magic_label = get_node("PC/VBC1/Magic Label")
  resistance_label = get_node("PC/VBC1/Resistance Label")
  health_label = get_node("PC/VBC1/Health Label")
  intelligence_label = get_node("PC/VBC1/Intelligence Label")
  control_label = get_node("PC/VBC1/Control Label")
  speed_label = get_node("PC/VBC1/Speed Label")
  
  attack_current = get_node("PC/VBC2/Attack")
  defense_current = get_node("PC/VBC2/Defense")
  magic_current = get_node("PC/VBC2/Magic")
  resistance_current = get_node("PC/VBC2/Resistance")
  health_current = get_node("PC/VBC2/Health")
  intelligence_current = get_node("PC/VBC2/Intelligence")
  control_current = get_node("PC/VBC2/Control")
  speed_current = get_node("PC/VBC2/Speed")
  
  remaining_points = get_node("PC/VBC3/Remaining")

func _on_attack_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(attack_current.text) - value
  if (change < 0 && attack_cost > points):
    attack.value = int(attack_current.text)
  else:
    remaining_points.text = str(abs(points + change * attack_cost))
    attack_current.text = str(value);

func _on_magic_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(magic_current.text) - value
  if (change < 0 && magic_cost > points):
    magic.value = int(magic_current.text)
  else:
    remaining_points.text = str(abs(points + change * magic_cost))
    magic_current.text = str(value);

func _on_defense_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(defense_current.text) - value
  if (change < 0 && defense_cost > points):
    defense.value = int(defense_current.text)
  else:
    remaining_points.text = str(abs(points + change * defense_cost))
    defense_current.text = str(value);

func _on_resistance_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(resistance_current.text) - value
  if (change < 0 && resistance_cost > points):
    resistance.value = int(resistance_current.text)
  else:
    remaining_points.text = str(abs(points + change * resistance_cost))
    resistance_current.text = str(value);

func _on_health_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(health_current.text) - value
  if (change < 0 && health_cost > points):
    health.value = int(health_current.text)
  else:
    remaining_points.text = str(abs(points + ((change * health_cost) /5)))
    health_current.text = str(value);

func _on_intelligence_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(intelligence_current.text) - value
  if (change < 0 && attack_cost > points):
    intelligence.value = int(intelligence_current.text)
  else:
    remaining_points.text = str(abs(points + change * intelligence_cost))
    intelligence_current.text = str(value);

func _on_control_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(control_current.text) - value
  if (change < 0 && control_cost > points):
    control.value = int(control_current.text)
  else:
    remaining_points.text = str(abs(points + change * control_cost))
    control_current.text = str(value);

func _on_speed_value_changed(value):
  var points = int(remaining_points.text)
  value = int(value)
  var change = int(speed_current.text) - value
  if (change < 0 && speed_cost > points):
    speed.value = int(speed_current.text)
  else:
    remaining_points.text = str(abs(points + change * speed_cost))
    speed_current.text = str(value);


func _on_randomize_pressed():
  print("Randomize pressed")
  var rng = RandomNumberGenerator.new()
  var map = [
    int(attack_base / 2),
    int(defense_base / 2),
    int(magic_base / 2),
    int(resistance_base / 2),
    int(health_base / 2),
    int(intelligence_base / 2),
    int(control_base / 2),
    int(speed_base / 2)
  ]
  
  attack.value = map[0]
  defense.value = map[1]
  magic.value = map[2]
  resistance.value = map[3]
  health.value = map[4]
  intelligence.value = map[5]
  control.value = map[6]
  speed.value = map[7]
  
  while (int(remaining_points.text) > 0):
    var rand
    if (int(remaining_points.text) > 1):
      rand = rng.randi_range(0,7)
    else:
      rand = rng.randi_range(4,7)
      
    if (rand == 0):
      attack.value += 1
    elif (rand == 1):
      defense.value += 1
    elif (rand == 2):
      magic.value += 1
    elif (rand == 3):
      resistance.value += 1
    elif (rand == 4):
      health.value += 5
    elif (rand == 5):
      intelligence.value += 1
    elif (rand == 6):
      control.value += 1
    elif (rand == 7):
      speed.value += 1


func _on_reset_pressed():
  print("Reset pressed")
  remaining_points.text = "1000"
  attack.value = attack_base
  defense.value = defense_base
  magic.value = magic_base
  resistance.value = resistance_base
  health.value = health_base
  intelligence.value = intelligence_base
  control.value = control_base
  speed.value = speed_base
  character_name.text = ""
  remaining_points.text = str(remaining_points_base)


func _on_save_pressed():
  print("Save pressed")
  var unit_details = '''{"{character_name}", new() 
  {
    { "Base Attack", {attack} },
    { "Base Defense", {defense} },
    { "Base Magic", {magic} },
    { "Base Resistance", {resistance} },
    { "Base Health", {health} },
    { "Base Intelligence", {intelligence} },
    { "Base Control", {control} },
    { "Base Speed", {speed} }
  }
}'''.format({"character_name": character_name.text,"attack": attack.value,"defense": defense.value,
"magic": magic.value, "resistance": resistance.value, "health": health.value, "intelligence": intelligence.value,
"control": control.value, "speed": speed.value})
  var file = FileAccess.open("data.txt", FileAccess.WRITE)
  file.store_string(unit_details)
  
