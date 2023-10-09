extends Area2D

@export var target_pos: Vector2
@export var is_down:bool
@export var new_clear_color:Color

func _on_body_entered(body):
	if body != null and "player" in body.name:
		body.on_pipe_entrance(target_pos, is_down, new_clear_color)


func _on_body_exited(body):
	if body != null and "player" in body.name:
		body.on_pipe_entrance_left()
