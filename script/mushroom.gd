extends RigidBody2D

@onready var ray_cast_left = $ray_cast_left
@onready var ray_cast_right = $ray_cast_right

const speed = 50
var velocity = speed
	
func _physics_process(delta):
	linear_velocity.x = velocity
	
	if ray_cast_left.is_colliding() and velocity < 0:
		if not "player" in ray_cast_left.get_collider().name:
			velocity = speed
		
	if ray_cast_right.is_colliding() and velocity > 0:
		if not "player" in ray_cast_right.get_collider().name:
			velocity = -speed


func _on_area_2d_body_entered(body):
	if "player" in body.name:
		body.eat_big_mushroom()
		queue_free()
