extends RigidBody2D

@onready var ray_cast_left = $ray_cast_left
@onready var ray_cast_right = $ray_cast_right
@onready var animation_player = $AnimationPlayer
@onready var collider = $CollisionShape2D

const speed = 15
const hit_time = 1000

var velocity = Vector2(-speed, 0)
var time_hit = -1
var hitted = false

func _ready():
	animation_player.play("walk")

func _physics_process(delta):
	if not hitted:
		move_and_collide(velocity * delta)
	
		if ray_cast_left.is_colliding():
			velocity.x = speed
			var hit_object = ray_cast_left.get_collider()
			if "player" in hit_object.name:
				hit_object.hit()
		if ray_cast_right.is_colliding():
			velocity.x = -speed
			var hit_object = ray_cast_right.get_collider()
			if "player" in hit_object.name:
				hit_object.hit()
			
			
	if hitted and Time.get_ticks_msec() - time_hit > hit_time:
		queue_free()
		
	
func hit():
	animation_player.play("hit")
	if collider != null:
		gravity_scale = 0
		collider.queue_free()
		freeze = true
		time_hit = Time.get_ticks_msec()
		hitted = true
