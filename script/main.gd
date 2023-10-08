extends Node2D


func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

func _load_level(level: int):
	get_tree().change_scene_to_file("res://scenes/level" + str(level) + ".tscn")

func _on_button_level_1_pressed():
	_load_level(1)
