extends CharacterBody2D

@export var speed: float = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0

func _process(delta):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func _physics_process(delta: float):
	#obter input vector
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
	
	# modificar velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	# atualizar is_running
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	if !is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
			
	#girar sprite
	if input_vector.x > 0:
		#desmarcar flip_h sprite2d
		sprite.flip_h = false
	elif input_vector.x < 0:
		#marcar flip_h sprite2d
		sprite.flip_h = true
		
	#ataque
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack():
	if is_attacking:
		return
		
	#attack_side_1
	#attack_side_2
	animation_player.play("attack_side_1")
	attack_cooldown = 0.6
	is_attacking = true
