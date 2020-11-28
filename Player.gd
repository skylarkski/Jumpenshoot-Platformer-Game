extends KinematicBody2D

const MOVE_SPEED = 500
const JUMP_FORCE = 1500
const GRAVITY = 70
const MAX_FALL_SPEED = 1500

const KNIFE = preload("res://Knife.tscn")


onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_velo = 0
var facing_right = false
var is_dead = false
var velocity = 0

func _physics_process(delta):
	
	if is_dead == false:
	#inputs
		var move_dir = 0
		if Input.is_action_pressed("move_right"):
			move_dir += 1
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		if Input.is_action_pressed("move_left"):
			move_dir -= 1
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		#KNIFE THROW
		if Input.is_action_just_pressed("shoot"):
			var knife = KNIFE.instance()
			if sign($Position2D.position.x) == 1:
				knife.set_knife_direction(1)
			else:
				knife.set_knife_direction(-1)
			
			get_parent().add_child(knife)
			knife.position = $Position2D.global_position
			
		move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
		
		var grounded = is_on_floor()
		y_velo += GRAVITY
		if grounded and Input.is_action_just_pressed("jump"):
			y_velo = -JUMP_FORCE
		if grounded and y_velo >= 5:
			y_velo = 5
		if y_velo > MAX_FALL_SPEED:
			y_velo = MAX_FALL_SPEED
		
		if facing_right and move_dir < 0:
			flip()
		if !facing_right and move_dir > 0:
			flip()
		
		if grounded:
			if move_dir == 0:
				play_anim("idle")
			else:
				play_anim("walk")
		else:
			play_anim("jump")
			
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()
			
			
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	play_anim("walk")
	$CollisionShape2D.disabled = true
	$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://TitleScreen.tscn")
	

