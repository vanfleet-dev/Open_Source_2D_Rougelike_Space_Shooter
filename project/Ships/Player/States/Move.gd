# A parent state for the player's finite state machine. Governs moving and
# controlling the player using linear and angular velocities, and how to
# transition through some of its child states, like docking or changing
# movement style between Travel and Precision.
extends PlayerState

export var drag_linear_coeff := 0.05
export var reverse_multiplier := 0.25

export var drag_angular_coeff := 0.1

var acceleration_max := 0.0
var linear_speed_max := 0.0
var angular_speed_max := 0.0
var angular_acceleration_max := 0.0

var linear_velocity := Vector2.ZERO
var angular_velocity := 0.0
var is_reversing := false
var can_fire := true

onready var agent := GSAIKinematicBody2DAgent.new(owner)


func _ready() -> void:
	yield(owner, "ready")

	acceleration_max = ship.stats.get_acceleration_max()
	linear_speed_max = ship.stats.get_linear_speed_max()
	angular_speed_max = ship.stats.get_angular_speed_max()
	angular_acceleration_max = ship.stats.get_angular_acceleration_max()

	agent.linear_acceleration_max = acceleration_max * reverse_multiplier
	agent.linear_speed_max = linear_speed_max
	agent.angular_acceleration_max = deg2rad(angular_acceleration_max)
	agent.angular_speed_max = deg2rad(angular_speed_max)
	agent.bounding_radius = (MathUtils.get_triangle_circumcircle_radius(ship.shape.polygon))


func physics_process(delta: float) -> void:
	linear_velocity = linear_velocity.clamped(linear_speed_max)
	linear_velocity = (linear_velocity.linear_interpolate(Vector2.ZERO, drag_linear_coeff))

	angular_velocity = clamp(angular_velocity, -agent.angular_speed_max, agent.angular_speed_max)
	angular_velocity = lerp(angular_velocity, 0, drag_angular_coeff)

	linear_velocity = ship.move_and_slide(linear_velocity)
	ship.rotation += angular_velocity * delta
	#kim removed see below
	#ship.vfx.make_trail(linear_velocity.length()) 
	#ship.vfx.make_trail2(linear_velocity.length()) #jvf added for 2nd particle effect





func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_dock") and ship.dockables.size() > 0:
		var dockable: Node2D
		while not dockable and ship.dockables.size() > 0:
			dockable = ship.dockables.back().get_ref()
			if not dockable:
				ship.dockables.pop_back()
		if dockable:
			_state_machine.transition_to(
				"Move/Dock",
				{
					position_docking_partner = dockable.global_position,
					radius_docking_partner = dockable.radius
				}
			)
	elif (
		event.is_action_pressed("precision_mode")
		or event.is_action_pressed("precision_mode_toggle")
	):
		_state_machine.transition_to(
			"Move/Precision", {toggled = event.is_action_pressed("precision_mode_toggle")}
		)
	#kim added. thruster vfx change. thrusters tied to movement input.
	if event.is_action_pressed("thrust_forwards"):
		ship.vfx.make_trail1(true)

	if event.is_action_pressed("thrust_forwards"):	
		ship.vfx.make_trail2(true) 
	
	if event.is_action_pressed("thrust_back"):
		ship.vfx.make_trail3(true) 

	if event.is_action_pressed("left"):
		ship.vfx.make_trail4(true) 

	if event.is_action_pressed("right"):
		ship.vfx.make_trail5(true)

	if event.is_action_released("thrust_forwards"):
		ship.vfx.make_trail1(false)
		
	if event.is_action_released("thrust_forwards"):
		ship.vfx.make_trail2(false)

	if event.is_action_released("thrust_back"):
		ship.vfx.make_trail3(false)

	if event.is_action_released("left"):
		ship.vfx.make_trail4(false)

	if event.is_action_released("right"):
		ship.vfx.make_trail5(false)