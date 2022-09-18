# State for the player's finite state machine. Travel mode moves with up meaning
# forwards relative to the orientation of the player's ship, with rotation done
# with left and right motion.
extends PlayerState

var reversing := false
onready var engine_audio1: AudioStreamPlayer2D = $EngineAudio1 #Kim-Lancaster
onready var engine_audio2: AudioStreamPlayer2D = $EngineAudio2
onready var engine_audio3: AudioStreamPlayer2D = $EngineAudio3
onready var engine_audio4: AudioStreamPlayer2D = $EngineAudio4

func physics_process(delta: float) -> void:
	var movement := get_movement()
	reversing = movement.y > 0
	var direction := GSAIUtils.angle_to_vector2(_parent.agent.orientation)
	
	# Kim Removed LoopAudioStreamPlayer2D from Travel.gd and 
	#ThrustersAudioPlayer from PlayerShip Scene. Replaced with a audio stream 
	#with only 1 audio file due to audio pops and clips during playback of 
	#multiple audio files. See commit 
	engine_audio1.global_position = owner.global_position
	if not engine_audio1.playing and Input.is_action_pressed("thrust_forwards"):
		engine_audio1.play()
	elif not Input.is_action_pressed("thrust_forwards"):
		engine_audio1.stop()
	## jvf tied user input to thruster audio effects. 
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


	_parent.linear_velocity += (
		movement.y
		* direction
		* _parent.acceleration_max
		* (_parent.reverse_multiplier if reversing else 1)
		* delta
	)
	_parent.angular_velocity += movement.x * _parent.agent.angular_acceleration_max * delta

	_parent.physics_process(delta)


func get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("thrust_back") - Input.get_action_strength("thrust_forwards")
	)


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if event.is_echo():
		return
	#jvf distortion effect removal test 1
	# if event.is_action("thrust_forwards") and event.is_pressed():
	# 	ship.vfx.create_shockwave()
		
