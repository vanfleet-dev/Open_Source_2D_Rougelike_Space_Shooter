extends Node2D

# rotation for planet and sats
export var rotation_speed = 0.1


func _process(delta):
	rotation += rotation_speed * delta
