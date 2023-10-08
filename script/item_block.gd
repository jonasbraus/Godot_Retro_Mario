extends Sprite2D

var hit_image = preload("res://assets/single/block_item_hit.png")
@export var item_prefab : PackedScene

var hitted = false

func hit():
	set_texture(hit_image)
	if item_prefab != null and not hitted:
		hitted = true
		var item = item_prefab.instantiate()
		get_parent().add_child(item)
		item.position.x = position.x
		item.position.y = position.y - 16
