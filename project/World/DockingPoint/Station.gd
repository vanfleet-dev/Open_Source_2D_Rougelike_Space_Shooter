# The player's station - consumes iron until an upgrade threshold is reached,
# then emits tot the gam that an upgrade has been unlocked.
class_name Station
extends DockingPoint

export var rotation_speed = 0.08

##anim stop for use with orbiting station
#onready var anim_player := $AnimationPlayer


func _process(delta):
	#rotation += rotation_speed * delta
	$Sprite/sat_1.rotation += rotation_speed * delta
	$Sprite/sat_2.rotation += rotation_speed * delta


export var upgrade_iron_amount := 99.0

var accumulated_iron := 0.0 setget _set_accumulated_iron


func _set_accumulated_iron(value: float) -> void:
	accumulated_iron = value
	if accumulated_iron >= upgrade_iron_amount:
		accumulated_iron = 0
		Events.emit_signal("upgrade_unlocked")
		upgrade_iron_amount *= 1.25


##anim stop for use with orbiting station

#func _on_DockingArea_body_entered(body: Node) -> void:
#	._on_DockingArea_body_entered(body)
#	anim_player.stop(false)


#unc _on_DockingArea_body_exited(body: Node) -> void:
#	._on_DockingArea_body_exited(body)
#	anim_player.play()
