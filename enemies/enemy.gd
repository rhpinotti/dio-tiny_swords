class_name Enemy

extends Node2D

@export var health: int = 10

func damage(amount: int):
	health -= amount
	print(health)
