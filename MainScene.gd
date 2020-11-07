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
		print("here")
		change_selection(null)

func change_selection(new_unit):
	if selected_unit and new_unit != selected_unit:
		print("changed")
		selected_unit.selected = false
	selected_unit = new_unit
	if new_unit:
		new_unit.selected = true
