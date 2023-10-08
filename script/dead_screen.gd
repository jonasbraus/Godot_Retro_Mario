extends Node2D

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)



func _on_button_retry_pressed():
	var file = FileAccess.open("user://current_level.txt", FileAccess.READ)
	var current_level = file.get_var()
	get_tree().change_scene_to_file("res://scenes/level" + str(current_level) + ".tscn")


func _on_button_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
