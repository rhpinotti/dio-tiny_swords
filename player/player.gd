extends CharacterBody2D

@export var speed: float = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var is_running: bool = false

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
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	# atualizar is_running
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
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
