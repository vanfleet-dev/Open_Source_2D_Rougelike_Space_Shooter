class_name PlanetSpawner
extends Node2D

export var TestPlanet1: PackedScene
export var min_distance_from_station := 1000.0

# func spawn_planet() -> void:
#     var planet = TestPlanet1.instance() #kim fixed
#     add_child(planet)
#     planet.global_position = (0, 0)
#     Events.emit_signal("planet_spawned", planet)

# func spawn_planet(rng: RandomNumberGenerator) -> void:
# 	var planet = TestPlanet1.instance()
# 	add_child(planet)
# 	planet.global_position = (
# 		Vector2.UP.rotated(rng.randf_range(0, PI * 2))
# 		* rng.randf_range(min_distance_from_station, 1000)
# 	)
# 	Events.emit_signal("planet_spawned", planet)


# func spawn_planet() -> void:
# 	var planet = TestPlanet1.instance()
# 	add_child(planet)
# 	Events.emit_signal("planet_spawned", planet)
