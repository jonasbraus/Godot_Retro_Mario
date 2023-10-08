extends Node2D

func _ready():
	var file = FileAccess.open("user://current_level.txt", FileAccess.WRITE)
	file.store_var(1)
	
	
