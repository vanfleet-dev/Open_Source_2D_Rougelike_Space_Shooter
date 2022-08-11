# State for the player's finite state machine. Precision movement mode controls
# the player ship by setting the keys to be up, down, left and right relative
# to the screen's orientation. The Face steering behavior will constantly
# turn to face the mouse, or the direction the right analog stick of
# a controller is pointing towards.
extends PlayerState

export var speed_multiplier := 0.75

var _face: GSAIFace
var _toggled := false

onready var _target_location := GSAIAgentLocation.new()
onready var acceleration := GSAITargetAcceleration.new()

onready var engine_audio1: AudioStreamPlayer2D = $EngineAudio1 #jvf added see below
onready var engine_audio2: AudioStreamPlayer2D = $EngineAudio2
onready var engine_audio3: AudioStreamPlayer2D = $EngineAudio3
onready var engine_audio4: AudioStreamPlayer2D = $EngineAudio4


func _ready() -> void:
	yield(owner, "ready")
	_face = GSAIFace.new(_parent.agent, _target_location)
	_face.alignment_tolerance = deg2rad(5)
	_face.deceleration_radius = deg2rad(45)


func enter(msg := {}) -> void:
	_toggled = msg.toggled
	if _toggled:
		var direction := GSAIUtils.angle_to_vector2(_parent.agent.orientation)
		_target_location.position.x = direction.x + _parent.agent.position.x
		_target_location.position.y = direction.y + _parent.agent.position.y
	else:
		_update_mouse_target()


func physics_process(delta: float) -> void:
	if _toggled:
		_update_stick_target()
	else:
		_update_mouse_target()

	var direction := get_movement()
	### jvf tied user input to thruster audio effects. 
	engine_audio1.global_position = owner.global_position
	if not engine_audio1.playing and Input.is_action_pressed("thrust_forwards"):
		engine_audio1.play()
	elif not Input.is_action_pressed("thrust_forwards"):
		engine_audio1.stop()
	engine_audio2.global_position = owner.global_position
	if not engine_audio2.playing and Input.is_action_pressed("thrust_back"):
		engine_audio2.play()
	elif not Input.is_action_pressed("thrust_back"):
		engine_audio2.stop()
	
	engine_audio3.global_position = owner.global_position
	if not engine_audio3.playing and Input.is_action_pressed("left"):
		engine_audio3.play()
	elif not Input.is_action_pressed("left"):
		engine_audio3.stop()

	engine_audio4.global_position = owner.global_position
	if not engine_audio4.playing and Input.is_action_pressed("right"):
		engine_audio4.play()
	elif not Input.is_action_pressed("right"):
		engine_audio4.stop()
	##
	_parent.linear_velocity += direction * _parent.acceleration_max * speed_multiplier * delta

	_face.calculate_steering(acceleration)
	_parent.angular_velocity += acceleration.angular * delta

	_parent.physics_process(delta)


func unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_released("precision_mode")
		or event.is_action_pressed("precision_mode_toggle")
	):
		_state_machine.transition_to("Move/Travel")
		return

	_parent.unhandled_input(event)


func get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("face_right") - Input.get_action_strength("face_left"),
		Input.get_action_strength("face_down") - Input.get_action_strength("face_up")
	)


func _update_mouse_target() -> void:
	var mouse_position: Vector2 = ship.get_global_mouse_position()
	_target_location.position.x = mouse_position.x
	_target_location.position.y = mouse_position.y


func _update_stick_target() -> void:
	var target_position := Vector2(_parent.agent.position.x, _parent.agent.position.y)
	var face_direction := get_direction() + target_position
	_target_location.position.x = face_direction.x
	_target_location.position.y = face_direction.y
