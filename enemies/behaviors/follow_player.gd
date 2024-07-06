extends Node

@export var speed = 1.0

var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
	if GameManager.is_game_over:
		return
		
	var input_vector = (GameManager.player_position - enemy.position).normalized()
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	#girar sprite
	if input_vector.x > 0:
		#desmarcar flip_h sprite2d
		sprite.flip_h = false
	elif input_vector.x < 0:
		#marcar flip_h sprite2d
		sprite.flip_h = true
