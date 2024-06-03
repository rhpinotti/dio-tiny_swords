extends CharacterBody2D

@export var speed = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var input_vector = (GameManager.player_position - position).normalized()
	velocity = input_vector * speed * 100.0
	move_and_slide()
	#girar sprite
	if input_vector.x > 0:
		#desmarcar flip_h sprite2d
		sprite.flip_h = false
	elif input_vector.x < 0:
		#marcar flip_h sprite2d
		sprite.flip_h = true
