# Spawns the station, asteroids, and pirates when entering the game.
# Keeps track of resources available in the world and which asteroid clusters holds it,
# and spawns more when running low.
# It also signals the pirate spawner when an upgrade has been made.
class_name GameWorld
extends Node2D

# Radius of the world in pixels.
export var radius := 20000.0

# Minimum amount of iron that must be added when the world spawns new asteroids.
# Used in `_spawn_asteroids`.
export var iron_amount_balance_level := 5000.0
# If the amouns of iron in the world goes below this threshold, spawns new asteroids.
export var refresh_threshold_range := 500.0

var _spawned_positions := []
var _world_objects := []
var _iron_clusters := {}

onready var rng := RandomNumberGenerator.new()

onready var station_spawner: StationSpawner = $StationSpawner
onready var asteroid_spawner: AsteroidSpawner = $AsteroidSpawner
onready var pirate_spawner: PirateSpawner = $PirateSpawner

# rotation for planet and sats
export var rotation_speed = 0.1
export var rotation_speed1 = 0.03
export var rotation_speed2 = 0.3
export var rotation_speed3 = 0.02
export var rotation_speed4 = 0.04
export var rotation_speed5 = 0.06
export var rotation_speed6 = 0.08

func _process(delta):
#twins sprites
	$Sun/twins_1.rotation += rotation_speed1 * delta
	$Sun/twins_1/twin_planet_1.rotation += rotation_speed1 * delta
#wet sprites
	$Sun/wet_1.rotation += rotation_speed1 * delta
	$Sun/wet_1/wet_moon_1.rotation += rotation_speed2 * delta
	$Sun/wet_1/wet_moon_1/wet_moon_1_sprite.rotation -= rotation_speed2 * delta
#gas sprites
	$Sun/gas_1.rotation += rotation_speed3 * delta
	$Sun/gas_1/gas_moon_1.rotation += rotation_speed4 * delta
	$Sun/gas_1/gas_moon_1/gas_moon_1_sprite.rotation -= rotation_speed4 * delta
	$Sun/gas_1/gas_moon_2.rotation += rotation_speed6 * delta
	$Sun/gas_1/gas_moon_2/gas_moon_2_sprite.rotation -= rotation_speed6 * delta
	$Sun/gas_1/gas_moon_3.rotation += rotation_speed5 * delta
	$Sun/gas_1/gas_moon_3/gas_moon_3_sprite.rotation -= rotation_speed5 * delta
#gas ring sprites
	$Sun/gas_1/gas_1_rings.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings2.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings3.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings4.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings5.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings6.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings7.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings8.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings9.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings10.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings11.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings12.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings13.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings14.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings15.rotation += rotation_speed1 * delta
	$Sun/gas_1/gas_1_rings16.rotation += rotation_speed1 * delta

func _ready() -> void:
	yield(owner, "ready")
	setup()


func setup() -> void:
	rng.randomize()

	Events.connect("upgrade_chosen", self, "_on_Events_upgrade_chosen")
	asteroid_spawner.connect("cluster_depleted", self, "_on_AsteroidSpawner_cluster_depleted")

	station_spawner.spawn_station(rng)
	asteroid_spawner.spawn_asteroid_clusters(rng, iron_amount_balance_level, radius)
	pirate_spawner.spawn_pirate_group(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)
	pirate_spawner.spawn_pirate_group2(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)
	pirate_spawner.spawn_pirate_group3(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)
	pirate_spawner.spawn_pirate_group4(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)
	pirate_spawner.spawn_pirate_group5(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)
	pirate_spawner.spawn_pirate_group6(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)
	pirate_spawner.spawn_pirate_group7(
		rng, 0, radius, _find_largest_inoccupied_asteroid_cluster().global_position
	)


# Returns the AsteroidCluster with the most iron that isn't occupied.
# If all clusters are occupied, returns `null`.
func _find_largest_inoccupied_asteroid_cluster() -> AsteroidCluster:
	var target_cluster: AsteroidCluster

	var target_cluster_iron_amount := -INF
	for cluster in asteroid_spawner.get_children():
		assert(cluster is AsteroidCluster)
		if cluster.is_occupied:
			continue
		if cluster.iron_amount > target_cluster_iron_amount:
			target_cluster = cluster
			target_cluster_iron_amount = cluster.iron_amount
	if target_cluster:
		target_cluster.is_occupied = true
	return target_cluster


# Spawn a new group of pirates upon getting an upgrade
func _on_Events_upgrade_chosen(_choice) -> void:
	var target_cluster := _find_largest_inoccupied_asteroid_cluster()
	if target_cluster:
		pirate_spawner.spawn_pirate_group(rng, 0, radius, target_cluster.global_position)


func _on_AsteroidSpawner_cluster_depleted(iron_left: float) -> void:
	if iron_left < refresh_threshold_range:
		asteroid_spawner.spawn_asteroid_clusters(rng, iron_amount_balance_level, radius)
