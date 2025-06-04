extends Control

func _on_calculator_pressed():
  var calculator_scene = preload("res://Calculator.tscn").instantiate()
  get_tree().root.add_child(calculator_scene)


func _on_dungeon_generator_pressed():
  var dungeonGenerator = preload("res://DungeonGenerator.tscn").instantiate();
  get_tree().root.add_child(dungeonGenerator);
