extends Sprite2D

@export var item_prefab : PackedScene

var hitted = false

func hit():
	if item_prefab != null and not hitted:
		hitted = true
		var item = item_prefab.instantiate()
		get_parent().add_child(item)
		item.position.x = position.x
		item.position.y = position.y - 16
	queue_free()
