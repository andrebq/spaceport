extends Node2D

var selected_unit:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _process(_delta):
	if selected_unit:
		$Camera2D.position = selected_unit.position

func _unhandled_input(event:InputEvent):
	if event.is_action("Click"):
		var click_point = get_viewport_transform().xform_inv(event.position)
		var space = get_world_2d().direct_space_state
		var units = space.intersect_point(click_point, 1)
		if units:
			var unit = units[0].collider
			if unit.has_signal("unit_selected"):
				change_selection(unit)
		elif selected_unit:
			# somehting is selected but we did not click
			# on other units
			selected_unit.destination = click_point
	elif event.is_action("RClick"):
		change_selection(null)

func change_selection(new_unit):
	if selected_unit and new_unit != selected_unit:
		selected_unit.selected = false
	selected_unit = new_unit
	if new_unit:
		new_unit.selected = true


func _on_SmallAsteroidMiner_autopilot_enabled(unit, global_destination) -> void:
	if selected_unit != unit:
		pass
	$DestinationPath.global_position = selected_unit.global_position
	var endPosition = global_destination - $DestinationPath.global_position
	$DestinationPath.points = [Vector2(0, 0), endPosition]
	$DestinationPath.visible = true
	print($DestinationPath.global_position, global_destination, $DestinationPath.points)


func _on_SmallAsteroidMiner_autopilot_disabled(unit, global_destination) -> void:
	if selected_unit != unit:
		pass
	$DestinationPath.visible = false
