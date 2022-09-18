#test planet
class_name TestPlanet1
extends DockingPoint

export var rotation_speed = 0.02

func _process(delta):
	rotation += rotation_speed * delta
