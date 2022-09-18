# The main camera that follows the location of the player. It manages
# zooming out when the map button is pressed, and manages the creation
# of a duplicate itself that will live in the minimap viewport, and will follow
# the original's position in the world using a `RemoteTransform2D`.
#
# The camera supports zooming and camera shake.
extends Camera2D

const SHAKE_EXPONENT := 0.8

###############################################
export var min_zoom := 0.5
export var max_zoom := 5
export var zoom_factor := 0.5
export var zoom_duration := 0.1

var _zoom_level := 3.0 setget _set_zoom_level


onready var tween: Tween = $Tween
###############################################

export var map_max_zoom := 20.0
export var decay_rate := 1.0
export var max_offset := Vector2(100.0, 100.0)
export var max_rotation := 0.1

var shake_amount := 0.0 setget set_shake_amount
var noise_y := 0.0

var _start_zoom := zoom
var _start_position := Vector2.ZERO

onready var remote_map := $RemoteMap
#jvf distortion effect removal test 1
#onready var remote_distort := $RemoteDistort


###########zoom test##########  onready var tween := $Tween


onready var noise := OpenSimplexNoise.new()


func _ready() -> void:
	set_physics_process(false)

	Events.connect("map_toggled", self, "_toggle_map")
	Events.connect("explosion_occurred", self, "_on_Events_explosion_occurred")

	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2


func _physics_process(delta):
	self.shake_amount -= decay_rate * delta
	shake()


func shake():
	var amount := pow(shake_amount, SHAKE_EXPONENT)

	noise_y += 1.0
	rotation = max_rotation * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset = Vector2(
		max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y),
		max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
	)


func set_shake_amount(value):
	shake_amount = clamp(value, 0.0, 1.0)
	set_physics_process(shake_amount != 0.0)


func setup_camera_map(map: MapView) -> void:
	var camera_map := self.duplicate()
	map.register_camera(camera_map)
	remote_map.remote_path = camera_map.get_path()


# func setup_distortion_camera() -> void:
# 	var distort_camera := self.duplicate()
# 	ObjectRegistry.register_distortion_effect(distort_camera)
# 	remote_distort.remote_path = distort_camera.get_path()


func _toggle_map(show: bool, duration: float) -> void:
	if show:
		tween.interpolate_property(
			self, "zoom", zoom, _start_zoom, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN
		)
	else:
		_start_position = position
		tween.interpolate_property(
			self,
			"zoom",
			zoom,
			Vector2(map_max_zoom, map_max_zoom),
			duration,
			Tween.TRANS_LINEAR,
			Tween.EASE_OUT_IN
		)
	tween.start()


## jvf zoom test

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE
	)
	tween.start()

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)


# func _unhandled_input(event):
# 	if event.is_action_pressed("zoom_in"):
# 		_set_zoom_level(_zoom_level - zoom_factor)
# 	if event.is_action_pressed("zoom_out"):
# 		_set_zoom_level(_zoom_level + zoom_factor)

##
