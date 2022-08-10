extends Node2D
# Visual Effects container. Provides a high level interface to create Ships visual effects

const TRAIL_VELOCITY_THRESHOLD := 200

onready var _ship_trail_1 := $MoveTrail1 #kim changed see below
onready var _shockwave := $Shockwave
onready var _ripple := $Ripple
onready var _dust_right := $DustRight
onready var _dust_left := $DustLeft


#kim changed to take a bool
func make_trail1(par: bool) -> void: #was the parameter (current_speed: float)
	_ship_trail_1.emitting = par #current_speed > TRAIL_VELOCITY_THRESHOLD


func create_shockwave() -> void:
	var shockwave := _shockwave.duplicate()
	ObjectRegistry.register_distortion_effect(shockwave)
	shockwave.global_position = _shockwave.global_position
	shockwave.emitting = true
	shockwave.get_node("LifeSpan").start()


func create_ripple() -> void:
	var ripple := _ripple.duplicate()
	ObjectRegistry.register_distortion_effect(ripple)
	ripple.global_position = _ripple.global_position
	ripple.emitting = true
	ripple.get_node("LifeSpan").start()


func create_dust() -> void:
	_dust_right.emitting = true
	_dust_left.emitting = true
