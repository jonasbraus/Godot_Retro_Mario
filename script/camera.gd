extends Camera2D

@onready var player = $"../player"

func _physics_process(delta):
	position.x = player.position.x
	if player.position.y > position.y or player.is_on_floor():
		position.y = int(player.position.y / 64) * 64
