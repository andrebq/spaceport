extends KinematicBody2D

signal unit_selected(unit)
signal unit_deselected(unit)

signal autopilot_enabled(unit,global_destination)
signal autopilot_disabled(unit,global_destination)

var selected:bool = false setget _set_selected
var show_health:bool = false setget _set_show_health
var start_driving:bool = false setget _set_start_driving
onready var destination:Vector2 = self.global_position setget _set_destination

func _set_start_driving(value):
	print("start driving: ", value)
	if start_driving == value:
		return
	
	start_driving = value
	if start_driving:
		emit_signal("autopilot_enabled", self, destination)
	else:
		emit_signal("autopilot_disabled", self, destination)

func _set_destination(value):
	if value == self.global_position:
		return
	destination = value
	self.start_driving = true

func _set_show_health(value):
	show_health = value
	$HUD/HealthBar.visible = value

func _set_selected(value):
	if selected and value:
		return
	elif selected and !value:
		selected = value
		emit_signal("unit_selected", self)
	elif !selected and value:
		selected = value
		emit_signal("unit_deselected", self)
	else:
		return
	$HUD/SelectionHUD.visible = selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if start_driving:
		var direction = self.global_position.direction_to(destination)
		var collision = move_and_collide(direction * 100 * delta)
		if collision:
			self.start_driving = false
			# handle collision later
		elif self.destination.distance_squared_to(self.global_position) <= 10:
			self.start_driving = false
