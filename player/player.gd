extends CharacterBody2D

@export var speed: float = 3
@export var sword_damage: int = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_side: bool = false
var attack_cooldown: float = 0.0

func _process(delta):
	GameManager.player_position = position
	
	read_input()
	update_attack_cooldown(delta)
	play_run_idle_animation()
	
	if !is_attacking:
		rotate_sprite()
		
	#ataque
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta: float):
	# modificar velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func update_attack_cooldown(delta):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func read_input():
	#obter input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
		
	# atualizar is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation():
	if !is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite():
	#girar sprite
	if input_vector.x > 0:
		#desmarcar flip_h sprite2d
		sprite.flip_h = false
	elif input_vector.x < 0:
		#marcar flip_h sprite2d
		sprite.flip_h = true

func attack():
	if is_attacking:
		return
	
	attack_side = !attack_side
	if attack_side:
		animation_player.play("attack_side_1")
	else:
		animation_player.play("attack_side_2")
		
	attack_cooldown = 0.6
	is_attacking = true
	
func deal_damage_to_enemies():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			#calcular dot product
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
