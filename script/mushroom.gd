extends RigidBody2D

@onready var ray_cast_left = $ray_cast_left
@onready var ray_cast_right = $ray_cast_right
@onready var ray_cast_up = $ray_cast_up
@onready var ray_cast_down = $ray_cast_down


const speed = 50
var velocity = Vector2(speed, 0)

var eaten = false

func _physics_process(delta):
	
	linear_velocity.x = velocity.x
	
	if not eaten:
		if ray_cast_left.is_colliding():
			var hit_object = ray_cast_left.get_collider()
			if "player" in hit_object.name:
				eaten = true
				hit_object.eat_big_mushroom()
				queue_free()
			elif velocity.x < 0:
				velocity.x = speed
				
		elif ray_cast_right.is_colliding():
			var hit_object = ray_cast_right.get_collider()
			if "player" in hit_object.name:
				eaten = true
				hit_object.eat_big_mushroom()
				queue_free()
			elif velocity.x > 0:
				velocity.x = -speed
				
		elif ray_cast_up.is_colliding():
			var hit_object = ray_cast_up.get_collider()
			if "player" in hit_object.name:
				eaten = true
				hit_object.eat_big_mushroom()
				queue_free()
		elif ray_cast_down.is_colliding():
			var hit_object = ray_cast_down.get_collider()
			if "player" in hit_object.name:
				eaten = true
				hit_object.eat_big_mushroom()
				queue_free()
