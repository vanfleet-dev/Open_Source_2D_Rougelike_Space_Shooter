extends Node2D
# Visual Effects container. Provides a high level interface to create Ships visual effects

const TRAIL_VELOCITY_THRESHOLD := 200

onready var _ship_trail_1 := $MoveTrail1 #kim changed see below
#jvf added for additional thruster particle effects
onready var _ship_trail_2 := $MoveTrail2 
onready var _ship_trail_3 := $MoveTrail3 
onready var _ship_trail_4 := $MoveTrail4 
onready var _ship_trail_5 := $MoveTrail5 
#jvf distortion effect removal test 1
#onready var _shockwave := $Shockwave
#onready var _ripple := $Ripple
onready var _dust_right := $DustRight
onready var _dust_left := $DustLeft

#kim changed to take a bool
func make_trail1(par: bool) -> void: #was the parameter (current_speed: float)
	_ship_trail_1.emitting = par #current_speed > TRAIL_VELOCITY_THRESHOLD

func make_trail2(par: bool) -> void:
	_ship_trail_2.emitting = par

func make_trail3(par: bool) -> void:
	_ship_trail_3.emitting = par

func make_trail4(par: bool) -> void:
	_ship_trail_4.emitting = par 

func make_trail5(par: bool) -> void:
	_ship_trail_5.emitting = par

# func create_shockwave() -> void:
# 	var shockwave := _shockwave.duplicate()
# 	ObjectRegistry.register_distortion_effect(shockwave)
# 	shockwave.global_position = _shockwave.global_position
# 	shockwave.emitting = true
# 	shockwave.get_node("LifeSpan").start()


# func create_ripple() -> void:
# 	var ripple := _ripple.duplicate()
# 	ObjectRegistry.register_distortion_effect(ripple)
# 	ripple.global_position = _ripple.global_position
# 	ripple.emitting = true
# 	ripple.get_node("LifeSpan").start()


func create_dust() -> void:
	_dust_right.emitting = true
	_dust_left.emitting = true
