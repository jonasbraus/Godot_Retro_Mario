extends Area2D

@onready var animation_player = $AnimationPlayer

var collected = false

func _ready():
	animation_player.play("idle")


func _on_body_entered(body):
	if "player" in body.name and not collected:
		collected = true
		body.collect_coin()
		queue_free()
