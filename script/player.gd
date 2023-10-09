extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const gravity = 800.0

@export var coin_label : Label
@export var control_pip : Control
@export var transition_scene : PackedScene

@onready var ray_cast_up = $ray_cast_up
@onready var ray_cast_down = $ray_cast_down
@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var collission_small = $collission_small

var joystick_anchor = Vector2.ZERO
var jump_anchor = Vector2.ZERO
var touch_axis = 0
var touch_jump = false
var touch_down = false

var is_big = false
var coins = 0

var pipe_down_possible = false
var pipe_down_target_pos
var pipe_clear_color = Color.BLACK
var time_pipe_entered = 0
var transition_scene_instance = null

func on_pipe_entrance(target_pos:Vector2, is_down:bool, new_clear_color:Color):
	if is_down:
		pipe_down_possible = true
		pipe_down_target_pos = target_pos
		pipe_clear_color = new_clear_color
	else:
		time_pipe_entered = Time.get_ticks_msec()
		transition_scene_instance = transition_scene.instantiate()
		get_parent().add_child(transition_scene_instance)
		RenderingServer.set_default_clear_color(new_clear_color)
		position = target_pos

func on_pipe_entrance_left():
	pipe_down_possible = false

func hit():
	if not is_big:
		get_tree().change_scene_to_file("res://scenes/dead_screen.tscn")
		var file = FileAccess.open("user://coins.txt", FileAccess.WRITE)
		file.store_var(coins)
	else:
		is_big = false
		collission_small.scale.y = 1
		ray_cast_down.scale.y = 1
		ray_cast_up.scale.y = 1
	
func collect_coin():
	coins += 1
	coin_label.text = str(coins)
	
func eat_big_mushroom():
	if not is_big:
		is_big = true
		position.y -= 16
		var position_beforce_scale = global_position
		collission_small.scale.y = 2
		ray_cast_down.scale.y = 2
		ray_cast_up.scale.y = 2
		global_position = position_beforce_scale
	else:
		coins += 5
		coin_label.text = str(coins)
	
func _ready():
	var file = FileAccess.open("user://coins.txt", FileAccess.READ)
	if file != null:
		coins = int(file.get_var())
		coin_label.text = str(coins)
	RenderingServer.set_default_clear_color(Color.ROYAL_BLUE)
	collission_small.scale.y = 1
	ray_cast_down.scale.y = 1
	ray_cast_up.scale.y = 1

func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if event.position.x < get_viewport_rect().size.x / 2:
			if event.is_pressed():
				joystick_anchor = event.position
			var anchor_offset = event.position.x - joystick_anchor.x
			if anchor_offset > 0:
				touch_axis = 1
			elif anchor_offset < 0:
				touch_axis = -1
			else:
				touch_axis = 0
			if event is InputEventScreenTouch and event.is_released():
				touch_axis = 0
		elif is_on_floor():
			if event.is_pressed():
				jump_anchor = event.position
			if event is InputEventScreenTouch and event.is_released():
				var anchor_offset = event.position.y - jump_anchor.y
				if anchor_offset > 20:
					touch_down = true
				else:
					touch_jump = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if (Input.is_action_just_pressed("jump") or touch_jump) and is_on_floor():
		touch_jump = false
		velocity.y = JUMP_VELOCITY

	if transition_scene_instance != null and Time.get_ticks_msec() - time_pipe_entered > 1000:
		get_parent().remove_child(transition_scene_instance)
		transition_scene_instance.queue_free()
		transition_scene_instance = null
	
	if touch_down or Input.is_action_just_pressed("down"):
		touch_down = false
		if pipe_down_possible:
			time_pipe_entered = Time.get_ticks_msec()
			transition_scene_instance = transition_scene.instantiate()
			get_parent().add_child(transition_scene_instance)
			position = pipe_down_target_pos
			RenderingServer.set_default_clear_color(pipe_clear_color)
	
	var direction = Input.get_axis("left", "right") + touch_axis
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			player_sprite.flip_h = true
		if velocity.x > 0:
			player_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.y < 0:
		if is_big:
			animation_player.play("jump_big")
		else:
			animation_player.play("jump")
	elif velocity.y > 0:
		if is_big:
			animation_player.play("fall_big")
		else:
			animation_player.play("fall")
	elif velocity.x != 0:
		if is_big:
			animation_player.play("walk_big")
		else:
			animation_player.play("walk")
	else:
		if is_big:
			animation_player.play("idle_big")
		else:
			animation_player.play("idle")
		
	if ray_cast_up.is_colliding():
		var hit_object = ray_cast_up.get_collider()
		if hit_object != null:
			hit_object = hit_object.get_parent()
			if "block_item" in hit_object.name or "block_breakable" in hit_object.name:
				hit_object.hit()
				
	if ray_cast_down.is_colliding():
		var hit_object = ray_cast_down.get_collider()
		if hit_object != null and "dead" in hit_object.name:
			get_tree().change_scene_to_file("res://scenes/dead_screen.tscn")
			var file = FileAccess.open("user://coins.txt", FileAccess.WRITE)
			file.store_var(coins)
		if hit_object != null and "gumba" in hit_object.name:
			hit_object.hit()
			velocity.y = JUMP_VELOCITY / 2

	move_and_slide()
	
