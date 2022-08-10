extends ProgressBar

export var Ore: PackedScene = preload("res://World/Ores/IronOre.tscn")

onready var cargo_bar := $CargoBar  # jvf removed radial progress bar. see below
onready var fill := $Fill
onready var tween := $Tween
onready var anim_player := $AnimationPlayer
onready var audio_unload: AudioStreamPlayer = $AudioUnload

var docked_position := Vector2.ZERO

var _player_is_mining := false


func _ready() -> void:
	Events.connect("docked", self, "_on_Events_docked")
	Events.connect("mine_started", self, "_on_Events_mine_started")
	Events.connect("mine_finished", self, "_on_Events_mine_finished")
	self.connect("value_changed", self, "_on_value_changed")
	share(cargo_bar) # jvf removed radial progress bar. see below


func initialize(player: PlayerShip) -> void:
	player.cargo.stats.connect("stat_changed", self, "_on_Stats_stat_changed")
	max_value = player.cargo.stats.get_max_cargo()
	value = player.cargo.stats.get_stat("cargo")


func spawn_ore() -> void:
	var ore := Ore.instance()
	add_child(ore)
	if _player_is_mining:
		ore.global_position = docked_position
		ore.animate_to(rect_global_position + rect_pivot_offset)
	else:
		ore.global_position = rect_global_position + rect_pivot_offset
		ore.animate_to(docked_position)
		audio_unload.play()


func _on_Events_docked(docking_point: DockingPoint) -> void:
	docked_position = docking_point.get_global_transform_with_canvas().origin


func _on_Events_mine_started(_mining_position: Vector2) -> void:
	_player_is_mining = true


func _on_Events_mine_finished() -> void:
	_player_is_mining = false


func _on_Stats_stat_changed(stat: String, _value_start: float, current_value: float) -> void:
	if not stat == "cargo":
		return
	value = current_value

# jvf removed radial mining progress bar. replaced with standard left to right progress bar.
func _on_value_changed(value_start: float, current_value: float) -> void:
	if tween.is_active():
		return
	tween.interpolate_property(
		"value", value_start, current_value, 0.25, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	tween.start()
	spawn_ore()


	# func _on_value_changed(_value: float) -> void:
	# 	if tween.is_active():
	# 		return
	# 	tween.interpolate_property(
	# 		fill,
	# 		"rect_scale",
	# 		fill.rect_scale,
	# 		Vector2(ratio, ratio),
	# 		0.25,
	# 		Tween.TRANS_ELASTIC,
	# 		Tween.EASE_OUT
	# 	)
	# 	tween.start()
	# 	spawn_ore()
